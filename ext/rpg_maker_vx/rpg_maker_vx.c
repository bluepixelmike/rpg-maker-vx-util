// rpg_maker_vx.c
// This file implements some of the functionality from the built-in RPG Maker classes.
// Only the functionality required to make this gem work is implemented here.

#include <stdio.h>
#include <ruby.h>

/**
 * Table class
 */

// Defines the Table class and its methods.
void define_tableClass()
{
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
void Init_rpg_maker_vx()
{
    define_tableClass();
    define_toneClass();
}
