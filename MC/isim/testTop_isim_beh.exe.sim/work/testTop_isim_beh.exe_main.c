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
    work_m_00000000004071265255_3078112465_init();
    xilinxcorelib_ver_m_00000000001358910285_1526464621_init();
    xilinxcorelib_ver_m_00000000001687936702_3029201355_init();
    xilinxcorelib_ver_m_00000000000277421008_2743149486_init();
    xilinxcorelib_ver_m_00000000001603977570_0824749404_init();
    work_m_00000000002489990758_1627723135_init();
    xilinxcorelib_ver_m_00000000001358910285_2740722860_init();
    xilinxcorelib_ver_m_00000000001687936702_1724394411_init();
    xilinxcorelib_ver_m_00000000000277421008_4147023147_init();
    xilinxcorelib_ver_m_00000000001603977570_1392965598_init();
    work_m_00000000000403262735_1512032686_init();
    xilinxcorelib_ver_m_00000000000277421008_2855664533_init();
    xilinxcorelib_ver_m_00000000001603977570_3288226073_init();
    work_m_00000000002489990758_1752532685_init();
    work_m_00000000000080293285_3823007873_init();
    work_m_00000000003377238058_0105085363_init();
    work_m_00000000004134447467_2073120511_init();


    xsi_register_tops("work_m_00000000003377238058_0105085363");
    xsi_register_tops("work_m_00000000004134447467_2073120511");


    return xsi_run_simulation(argc, argv);

}
