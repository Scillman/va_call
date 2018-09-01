#include <stdio.h>


/**
 * Our assembly function.
 * @param arg#0 The virtual address of the function to call.
 * @param ... The parameters that need to be passed to the function.
 */
extern "C" void __cdecl va_call(uintptr_t, ...);


#pragma optimize( "", off )
// Disable optimization to prevent any
// form of inlining this function.
void __cdecl va_test(void *ptr)
{
    printf("va_test (%p)\n", ptr);
}
#pragma optimize( "", on )


/**
 * Program entry point. UNICODE for Windows.
 */
int wmain(int argc, wchar_t **argv)
{
    int value;

    // NOTE: Even if the program is
    // terminated due to an incorrect
    // build this is still displayed and
    // executed.
    value = 1;
    printf("[%i] start\n", value);
    va_test(&va_test);


    // This is the magical function,
    // where we call va_test using its
    // virtual address. It uses the same
    // data as the call above.
    value = 2;
    printf("[%i] value:\n", value);
    va_call(0x00801040, &va_test);


    // NOTE: Should be displayed if the
    // function has been executed
    // successfully. In other scenarios
    // the stack is likely to be wrongly
    // aligned, etc.
    value = 3;
    printf("[%i] end\n", value);


    return 0;
}
