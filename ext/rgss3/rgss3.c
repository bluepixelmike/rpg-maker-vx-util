// rgss3.c
// This file implements some of the functionality from RGSS3.
// Only the functionality required to make this gem work is implemented here.

#include <stdio.h>
#include <ruby.h>

/**
 * Table class
 */

#define TABLE_MARSHAL_VERSION 2

#define FLAT_INDEX(X, Y, Z, WIDTH, HEIGHT) X + WIDTH * (Y + HEIGHT * Z)

#define TABLE_INDEX(TABLE, X, Y, Z) FLAT_INDEX(X, Y, Z, TABLE->x, TABLE->y)

struct table {
    int x, y, z;
    int size;
    signed short int *data;
};

// Prototypes
VALUE allocateTableClass(VALUE klass);
void freeTableClass(void *tablePtr);
VALUE tableClass_initialize(int argc, VALUE *argv, VALUE self);
VALUE tableClass_resize(int argc, VALUE *argv, VALUE self);
VALUE tableClass_getXSize(VALUE self);
VALUE tableClass_getYSize(VALUE self);
VALUE tableClass_getZSize(VALUE self);
VALUE tableClass_getElement(int argc, VALUE *argv, VALUE self);
VALUE tableClass_setElement(int argc, VALUE *argv, VALUE self);
// TODO: Marshaled data is stored as little-endian. Make sure to convert if needed.
VALUE tableClass_load(VALUE tableClass, VALUE marshaled);
VALUE tableClass_dump(VALUE self, VALUE level);

// Defines the Table class and its methods.
void define_tableClass()
{
    // Create table class.
    VALUE tableClass = rb_define_class("Table", rb_cObject);
    rb_define_alloc_func(tableClass, allocateTableClass);

    // Define its methods.
    rb_define_method(tableClass, "initialize", tableClass_initialize, -1);
    rb_define_method(tableClass, "resize",     tableClass_resize,     -1);
    rb_define_method(tableClass, "xsize",      tableClass_getXSize,    0);
    rb_define_method(tableClass, "ysize",      tableClass_getYSize,    0);
    rb_define_method(tableClass, "zsize",      tableClass_getZSize,    0);
    rb_define_method(tableClass, "[]",         tableClass_getElement, -1);
    rb_define_method(tableClass, "[]=",        tableClass_setElement, -1);

    // Define special marshal methods.
    rb_define_singleton_method(tableClass, "_load", tableClass_load, 1);
    rb_define_method(tableClass, "_dump", tableClass_dump, 1);
}

// Implementation

VALUE allocateTableClass(VALUE klass)
{
    struct table *table;
    return Data_Make_Struct(klass, struct table, 0, freeTableClass, table);
}

void freeTableClass(void *tablePtr)
{
    struct table *table = (struct table *)tablePtr;
    free(table->data);
    free(table);
}

VALUE tableClass_initialize(int argc, VALUE *argv, VALUE self)
{
    struct table *table;
    VALUE xsize, ysize, zsize;

    if(rb_scan_args(argc, argv, "12", &xsize, &ysize, &zsize))
    {// xsize [, ysize [, zsize]]
        Data_Get_Struct(self, struct table, table);
        int x = NUM2INT(xsize);
        int y = NIL_P(ysize) ? 1 : NUM2INT(ysize);
        int z = NIL_P(zsize) ? 1 : NUM2INT(zsize);
        int size = x * y * z;
        int dataLen = sizeof(signed short int) * size;
        signed short int *data = (signed short int *)malloc(dataLen);
        memset(data, 0, dataLen);

        table->x    = x;
        table->y    = y;
        table->z    = z;
        table->size = size;
        table->data = data;
    }

     return self;
}

VALUE tableClass_resize(int argc, VALUE *argv, VALUE self)
{
    struct table *table;
    VALUE xsize, ysize, zsize;

    if(rb_scan_args(argc, argv, "12", &xsize, &ysize, &zsize))
    {// xsize [, ysize [, zsize]]
        Data_Get_Struct(self, struct table, table);
        int newX = NUM2INT(xsize);
        int newY = NIL_P(ysize) ? 1 : NUM2INT(ysize);
        int newZ = NIL_P(zsize) ? 1 : NUM2INT(zsize);
        int newSize = newX * newY * newZ;
        int dataLen = sizeof(signed short int) * newSize;
        signed short int *newData = (signed short int *)malloc(dataLen);
        memset(newData, 0, dataLen);

        int prevX = table->x;
        int prevY = table->y;
        int prevZ = table->z;
        signed short int *prevData = table->data;

        int minX = prevX < newX ? prevX : newX;
        int minY = prevY < newY ? prevY : newY;
        int minZ = prevZ < newZ ? prevZ : newZ;

        int y, z;
        int rowSize = minX * sizeof(signed short int);
        for(z = 0; z < minZ; ++z)
            for(y = 0; y < minY; ++y)
            {
                int srcIndex  = FLAT_INDEX(0, y, z, prevX, prevY);
                int destIndex = FLAT_INDEX(0, y, z, newX, newY);
                memcpy(&newData[destIndex], &prevData[srcIndex], rowSize);
            }

        table->x    = newX;
        table->y    = newY;
        table->z    = newZ;
        table->size = newSize;
        table->data = newData;

        free(prevData);
    }

    return self;
}

VALUE tableClass_getXSize(VALUE self)
{
    struct table *table;
    Data_Get_Struct(self, struct table, table);
    return INT2FIX(table->x);
}

VALUE tableClass_getYSize(VALUE self)
{
    struct table *table;
    Data_Get_Struct(self, struct table, table);
    return INT2FIX(table->y);
}

VALUE tableClass_getZSize(VALUE self)
{
    struct table *table;
    Data_Get_Struct(self, struct table, table);
    return INT2FIX(table->z);
}

VALUE tableClass_getElement(int argc, VALUE *argv, VALUE self)
{
    struct table *table;
    Data_Get_Struct(self, struct table, table);

    VALUE xval, yval, zval;
    if(rb_scan_args(argc, argv, "12", &xval, &yval, &zval))
    {// x [, y [, z]]
        int x = NUM2INT(xval);
        int y = NIL_P(yval) ? 0 : NUM2INT(yval);
        int z = NIL_P(zval) ? 0 : NUM2INT(zval);
        int index = TABLE_INDEX(table, x, y, z);
        return INT2FIX(table->data[index]);
    }

     return Qnil;
}

VALUE tableClass_setElement(int argc, VALUE *argv, VALUE self)
{
    struct table *table;
    Data_Get_Struct(self, struct table, table);

    VALUE val1, val2, val3, val4;
    int value;
    if(rb_scan_args(argc, argv, "22", &val1, &val2, &val3, &val4))
    {// x [, y [, z]] = value
        int x, y, z;
        x = NUM2INT(val1);
        if(NIL_P(val3))
        {// [x] = value
            y     = 0;
            z     = 0;
            value = NUM2INT(val2);
        }
        else if(NIL_P(val4))
        {// [x, y] = value
            y     = NUM2INT(val2);
            z     = 0;
            value = NUM2INT(val3);
        }
        else
        {// [x, y, z] = value
            y     = NUM2INT(val2);
            z     = NUM2INT(val3);
            value = NUM2INT(val4);
        }
        int index = TABLE_INDEX(table, x, y, z);
        table->data[index] = value;
    }

    return INT2FIX(value);
}

VALUE tableClass_load(VALUE tableClass, VALUE marshaled)
{
    int version, xsize, ysize, zsize, size;
    char *marshaledBytes = StringValuePtr(marshaled);
    memcpy(&version, &marshaledBytes[0],  4);
    memcpy(&xsize,   &marshaledBytes[4],  4);
    memcpy(&ysize,   &marshaledBytes[8],  4);
    memcpy(&zsize,   &marshaledBytes[12], 4);
    memcpy(&size,    &marshaledBytes[16], 4);
    // TODO: Assert version == 2
    // TODO: Assert size == xsize * ysize * zsize
    int dataLen = sizeof(signed short int) * size;
    signed short int *data = (signed short int *)malloc(dataLen);
    memcpy(data, &marshaledBytes[20], dataLen);

    VALUE self = allocateTableClass(tableClass);
    struct table *table;
    Data_Get_Struct(self, struct table, table);
    table->x    = xsize;
    table->y    = ysize;
    table->z    = zsize;
    table->size = size;
    table->data = data;
    return self;
}

VALUE tableClass_dump(VALUE self, VALUE level)
{
    struct table *table;
    Data_Get_Struct(self, struct table, table);
    int version = TABLE_MARSHAL_VERSION;
    int xsize   = table->x;
    int ysize   = table->y;
    int zsize   = table->z;
    int size    = table->size;
    int dataLen = sizeof(signed short int) * size;
    int marshalLen = dataLen + 20;
    char *marshaledBytes = (char *)malloc(marshalLen);
    memcpy(&marshaledBytes[0],  &version,    4);
    memcpy(&marshaledBytes[4],  &xsize,      4);
    memcpy(&marshaledBytes[8],  &ysize,      4);
    memcpy(&marshaledBytes[12], &zsize,      4);
    memcpy(&marshaledBytes[16], &size,       4);
    memcpy(&marshaledBytes[20], table->data, dataLen);
    return rb_str_new(marshaledBytes, marshalLen);
}

/**
 * Tone class
 */

// Defines the Tone class and its methods.
void define_toneClass()
{
}

/**
 * Initialization
 */

// Entry point called by Ruby.
void Init_rgss3()
{
    define_tableClass();
    define_toneClass();
}
