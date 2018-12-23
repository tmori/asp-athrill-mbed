/*
 *  TTSP
 *      TOPPERS Test Suite Package
 * 
 *  Copyright (C) 2010-2011 by Center for Embedded Computing Systems
 *              Graduate School of Information Science, Nagoya Univ., JAPAN
 *  Copyright (C) 2010-2011 by Digital Craft Inc.
 *  Copyright (C) 2010-2011 by NEC Communication Systems, Ltd.
 *  Copyright (C) 2010-2011 by FUJISOFT INCORPORATED
 * 
 *  �嵭����Ԥϡ��ʲ���(1)��(4)�ξ������������˸¤ꡤ�ܥ��եȥ���
 *  �����ܥ��եȥ���������Ѥ�����Τ�ޤࡥ�ʲ�Ʊ���ˤ���ѡ�ʣ������
 *  �ѡ������ۡʰʲ������ѤȸƤ֡ˤ��뤳�Ȥ�̵���ǵ������롥
 *  (1) �ܥ��եȥ������򥽡��������ɤη������Ѥ�����ˤϡ��嵭������
 *      ��ɽ�����������Ѿ�浪��Ӳ�����̵�ݾڵ��꤬�����Τޤޤη��ǥ���
 *      ����������˴ޤޤ�Ƥ��뤳�ȡ�
 *  (2) �ܥ��եȥ������򡤥饤�֥������ʤɡ�¾�Υ��եȥ�������ȯ�˻�
 *      �ѤǤ�����Ǻ����ۤ�����ˤϡ������ۤ�ȼ���ɥ�����ȡ�����
 *      �ԥޥ˥奢��ʤɡˤˡ��嵭�����ɽ�����������Ѿ�浪��Ӳ���
 *      ��̵�ݾڵ����Ǻܤ��뤳�ȡ�
 *  (3) �ܥ��եȥ������򡤵�����Ȥ߹���ʤɡ�¾�Υ��եȥ�������ȯ�˻�
 *      �ѤǤ��ʤ����Ǻ����ۤ�����ˤϡ����Τ����줫�ξ�����������
 *      �ȡ�
 *    (a) �����ۤ�ȼ���ɥ�����ȡ����Ѽԥޥ˥奢��ʤɡˤˡ��嵭����
 *        �ɽ�����������Ѿ�浪��Ӳ�����̵�ݾڵ����Ǻܤ��뤳�ȡ�
 *    (b) �����ۤη��֤��̤�������ˡ�ˤ�äơ�TOPPERS�ץ������Ȥ�
 *        ��𤹤뤳�ȡ�
 *  (4) �ܥ��եȥ����������Ѥˤ��ľ��Ū�ޤ��ϴ���Ū�������뤤���ʤ�»
 *      ������⡤�嵭����Ԥ����TOPPERS�ץ������Ȥ����դ��뤳�ȡ�
 *      �ޤ����ܥ��եȥ������Υ桼���ޤ��ϥ���ɥ桼������Τ����ʤ���
 *      ͳ�˴�Ť����ᤫ��⡤�嵭����Ԥ����TOPPERS�ץ������Ȥ�
 *      ���դ��뤳�ȡ�
 * 
 *  �ܥ��եȥ������ϡ�̵�ݾڤ��󶡤���Ƥ����ΤǤ��롥�嵭����Ԥ�
 *  ���TOPPERS�ץ������Ȥϡ��ܥ��եȥ������˴ؤ��ơ�����λ�����Ū
 *  ���Ф���Ŭ������ޤ�ơ������ʤ��ݾڤ�Ԥ�ʤ����ޤ����ܥ��եȥ���
 *  �������Ѥˤ��ľ��Ū�ޤ��ϴ���Ū�������������ʤ�»���˴ؤ��Ƥ⡤��
 *  ����Ǥ�����ʤ���
 * 
 *  $Id: out.c 2 2012-05-09 02:23:52Z nces-shigihara $
 */

#include <kernel.h>
#include <t_syslog.h>
#include "syssvc/syslog.h"
#include "kernel_cfg.h"
#include "ttsp_test_lib.h"
#include "out.h"

void main_task(intptr_t exinf){
	ER ercd;

	ttsp_initialize_test_lib();

	ttsp_check_point(1);


	/* CPU�㳰ȯ������������ */

	/* CPU�㳰�򵯤��� */
	ttsp_cpuexc_raise(TTSP_EXCNO_A);
	ttsp_wait_check_point(2);

	ttsp_check_point(3);


	/* CPU�㳰ȯ�������������㳰�����롼���� */

  	/* �������㳰���ľ��֤ˤ��� */
	ercd = ena_tex();
	check_ercd(ercd, E_OK);

	/* �������㳰�򵯤��� */
	ercd = ras_tex(TSK_SELF, 0x00000001);
	check_ercd(ercd, E_OK);

	ttsp_check_point(7);


	/* CPU�㳰ȯ���������顼��ϥ�ɥ� */

	/* ���顼��ϥ�ɥ�򵯤��� */
	ercd = sta_alm(ALM1, 0);
	check_ercd(ercd, E_OK);

	dly_tsk(10);

	ttsp_check_point(11);


	/* CPU�㳰ȯ�����������ϥ�ɥ� */

	/* �����ϥ�ɥ�򵯤��� */
	ercd = sta_cyc(CYC1);
	check_ercd(ercd, E_OK);

	dly_tsk(10);

	/* �����ϥ�ɥ��λ������ */
	ercd = stp_cyc(CYC1);
	check_ercd(ercd, E_OK);

	ttsp_check_finish(15);
}

void exception_ttsp_excno_a(void* p_excinf){
	static uint_t bootcnt = 0;

	bootcnt++;

	ttsp_cpuexc_hook(TTSP_EXCNO_A, p_excinf);

	if (bootcnt == 1){
		syslog_0(LOG_NOTICE, "[TSK]ttsp_cpuexc_raise(TTSP_EXCNO_A) : OK");

		ttsp_check_point(2);
	}
	if(bootcnt == 2){
		syslog_0(LOG_NOTICE, "[TEX]ttsp_cpuexc_raise(TTSP_EXCNO_A) : OK");

		ttsp_check_point(5);
	}
	if(bootcnt == 3){
		syslog_0(LOG_NOTICE, "[ALM]ttsp_cpuexc_raise(TTSP_EXCNO_A) : OK");

		ttsp_check_point(9);
	}
	if(bootcnt == 4){
		syslog_0(LOG_NOTICE, "[CYC]ttsp_cpuexc_raise(TTSP_EXCNO_A) : OK");

		ttsp_check_point(13);
	}
}

void texhdr_tex(TEXPTN texptn, intptr_t exinf){

	ttsp_check_point(4);

	ttsp_cpuexc_raise(TTSP_EXCNO_A);
	ttsp_wait_check_point(5);

	ttsp_check_point(6);
}

void almhdr_alm(intptr_t exinf){

	ttsp_check_point(8);

	ttsp_cpuexc_raise(TTSP_EXCNO_A);
	ttsp_wait_check_point(9);

	ttsp_check_point(10);
}

void cychdr_cyc(intptr_t exinf){

	ttsp_check_point(12);

	ttsp_cpuexc_raise(TTSP_EXCNO_A);
	ttsp_wait_check_point(13);

	ttsp_check_point(14);
}
