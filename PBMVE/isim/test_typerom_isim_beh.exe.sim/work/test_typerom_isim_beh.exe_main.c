/**********************************************************************/
/*   ____  ____                                                       */
/*  /   /\/   /                                                       */
/* /___/  \  /                                                        */
/* \   \   \/                                                       */
/*  \   \        Copyright (c) 2003-2009 Xilinx, Inc.                */
/*  /   /          All Right Reserved.                                 */
/* /---/   /\                                                         */
/* \   \  /  \                                                      */
/*  \___\/\___\                                                    */
/***********************************************************************/

#include "xsi.h"

struct XSI_INFO xsi_info;



int main(int argc, char **argv)
{
    xsi_init_design(argc, argv);
    xsi_register_info(&xsi_info);

    xsi_register_min_prec_unit(-12);
    xilinxcorelib_ver_m_00000000001358910285_2530306912_init();
    xilinxcorelib_ver_m_00000000001687936702_1106511808_init();
    xilinxcorelib_ver_m_00000000000277421008_1340526258_init();
    xilinxcorelib_ver_m_00000000001603977570_1742784114_init();
    work_m_00000000002489990758_1969543310_init();
    work_m_00000000003700545008_2287293065_init();
    xilinxcorelib_ver_m_00000000001358910285_2497935475_init();
    xilinxcorelib_ver_m_00000000001687936702_2225106775_init();
    xilinxcorelib_ver_m_00000000000277421008_1298840395_init();
    xilinxcorelib_ver_m_00000000001603977570_2133880304_init();
    work_m_00000000000403262735_3382247241_init();
    xilinxcorelib_ver_m_00000000001358910285_4121387242_init();
    xilinxcorelib_ver_m_00000000001687936702_0829056916_init();
    xilinxcorelib_ver_m_00000000000277421008_1524707169_init();
    xilinxcorelib_ver_m_00000000001603977570_0146481160_init();
    work_m_00000000000403262735_1560241096_init();
    work_m_00000000004035052875_3823007873_init();
    work_m_00000000000725517702_2025920804_init();
    work_m_00000000004134447467_2073120511_init();


    xsi_register_tops("work_m_00000000000725517702_2025920804");
    xsi_register_tops("work_m_00000000004134447467_2073120511");


    return xsi_run_simulation(argc, argv);

}
