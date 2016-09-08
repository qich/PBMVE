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
    work_m_00000000002442728285_2901097989_init();
    xilinxcorelib_ver_m_00000000001358910285_2497935475_init();
    xilinxcorelib_ver_m_00000000001687936702_2225106775_init();
    xilinxcorelib_ver_m_00000000000277421008_2628727902_init();
    xilinxcorelib_ver_m_00000000001603977570_2346616152_init();
    work_m_00000000000403262735_0511313860_init();
    work_m_00000000000068392615_0602693225_init();
    work_m_00000000000406532143_3438559617_init();
    work_m_00000000004134447467_2073120511_init();


    xsi_register_tops("work_m_00000000000406532143_3438559617");
    xsi_register_tops("work_m_00000000004134447467_2073120511");


    return xsi_run_simulation(argc, argv);

}
