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

typedef struct{
	EXCNO excno;
	ID almid;
	ID cycid;
}PRC_INFO;

PRC_INFO prc_info[] = {
#ifdef TOPPERS_SYSTIM_LOCAL
	{TTSP_EXCNO_A,     ALM1, CYC1},
#if TNUM_PRCID >= 2
	{TTSP_EXCNO_PE2_A, ALM2, CYC2},
#endif /* TNUM_PRCID >= 2 */
#if TNUM_PRCID >= 3
	{TTSP_EXCNO_PE3_A, ALM3, CYC3},
#endif /* TNUM_PRCID >= 3 */
#if TNUM_PRCID >= 4
	{TTSP_EXCNO_PE4_A, ALM4, CYC4}
#endif /* TNUM_PRCID >= 4 */
#else /* TOPPERS_SYSTIM_GLOBAL */
	{TTSP_EXCNO_A,     ALM1, CYC1},
#if TNUM_PRCID >= 2
	{TTSP_EXCNO_PE2_A, ALM1, CYC1},
#endif /* TNUM_PRCID >= 2 */
#if TNUM_PRCID >= 3
	{TTSP_EXCNO_PE3_A, ALM1, CYC1},
#endif /* TNUM_PRCID >= 3 */
#if TNUM_PRCID >= 4
	{TTSP_EXCNO_PE4_A, ALM1, CYC1}
#endif /* TNUM_PRCID >= 4 */
#endif /* TOPPERS_SYSTIM_LOCAL */
};

void main_task(intptr_t exinf){
	uint_t i;
	ER ercd;
	EXCNO excno = prc_info[(int)exinf].excno;
	ID almid = prc_info[(int)exinf].almid;
	ID cycid = prc_info[(int)exinf].cycid;
	ID prcid;
	get_pid(&prcid);
	i = 0;

	ttsp_mp_check_point(prcid, 1);

	/* CPU�㳰ȯ������������ */

	/* CPU�㳰�򵯤��� */
	ttsp_cpuexc_raise(excno);
	ttsp_mp_wait_check_point(prcid, 2);

	ttsp_mp_check_point(prcid, 3);

	/* CPU�㳰ȯ�������������㳰�����롼���� */

  	/* �������㳰���ľ��֤ˤ��� */
	ercd = ena_tex();
	check_ercd(ercd, E_OK);
  
	/* �������㳰�򵯤��� */
	ercd = ras_tex(TSK_SELF, 0x00000001);
	check_ercd(ercd, E_OK);
  
	ttsp_mp_check_point(prcid, 7);


#ifdef TOPPERS_SYSTIM_GLOBAL
	if (TOPPERS_SYSTIM_PRCID == prcid) {
#endif /* TOPPERS_SYSTIM_GLOBAL */

	/* CPU�㳰ȯ���������顼��ϥ�ɥ� */

	/* ���顼��ϥ�ɥ�򵯤��� */
	ercd = sta_alm(almid, 0);
	check_ercd(ercd, E_OK);

	ttsp_mp_wait_check_point(prcid, 8);

	ttsp_mp_check_point(prcid, 11);


	/* CPU�㳰ȯ�����������ϥ�ɥ� */

	/* �����ϥ�ɥ�򵯤��� */
	ercd = sta_cyc(cycid);
	check_ercd(ercd, E_OK);

	ttsp_mp_wait_check_point(prcid, 12);

	/* �����ϥ�ɥ��λ������ */
	ercd = stp_cyc(cycid);
	check_ercd(ercd, E_OK);

#ifdef TOPPERS_SYSTIM_GLOBAL
	}
	if ((TOPPERS_MASTER_PRCID != TOPPERS_SYSTIM_PRCID) && (TOPPERS_MASTER_PRCID == prcid)) {
		for (i = 8; i <= 14; i++) {
			ttsp_mp_check_point(prcid, i);
		}
	}
#endif /* TOPPERS_SYSTIM_GLOBAL */

	ttsp_barrier_sync(1, TNUM_PRCID);

	if (TOPPERS_MASTER_PRCID == prcid) {
		ttsp_mp_check_finish(prcid, 15);
	}
}

void exc(void* p_excinf){
	static uint_t bootcnt[4] = {0};
	EXCNO excno;
	ID prcid;
	iget_pid(&prcid);

	bootcnt[prcid - 1]++;
	excno = prc_info[prcid - 1].excno;

	ttsp_cpuexc_hook(excno, p_excinf);

	if (bootcnt[prcid - 1] == 1) {
		syslog_2(LOG_NOTICE, "[TSK%d]ttsp_cpuexc_raise(0x%x) : OK", prcid, excno);
		ttsp_mp_check_point(prcid, 2);
	}
	if (bootcnt[prcid - 1] == 2) {
		syslog_2(LOG_NOTICE, "[TEX%d]ttsp_cpuexc_raise(0x%x) : OK", prcid, excno);
		ttsp_mp_check_point(prcid, 5);
	}
	if (bootcnt[prcid - 1] == 3) {
		syslog_2(LOG_NOTICE, "[ALM%d]ttsp_cpuexc_raise(0x%x) : OK", prcid, excno);
		ttsp_mp_check_point(prcid, 9);
	}
	if (bootcnt[prcid - 1] == 4) {
		syslog_2(LOG_NOTICE, "[CYC%d]ttsp_cpuexc_raise(0x%x) : OK", prcid, excno);
		ttsp_mp_check_point(prcid, 13);
	}
}

void tex(TEXPTN texptn, intptr_t exinf){
	EXCNO excno = prc_info[(int)exinf].excno;
	ID prcid;
	get_pid(&prcid);

	ttsp_mp_check_point(prcid, 4);

	ttsp_cpuexc_raise(excno);
	ttsp_mp_wait_check_point(prcid, 5);

	ttsp_mp_check_point(prcid, 6);
}

void alm(intptr_t exinf){
	EXCNO excno = prc_info[(int)exinf].excno;
	ID prcid;
	iget_pid(&prcid);

	ttsp_mp_check_point(prcid, 8);

	ttsp_cpuexc_raise(excno);
	ttsp_mp_wait_check_point(prcid, 9);

	ttsp_mp_check_point(prcid, 10);
}

void cyc(intptr_t exinf){
	EXCNO excno = prc_info[(int)exinf].excno;
	ID prcid;
	iget_pid(&prcid);

	ttsp_mp_check_point(prcid, 12);

	ttsp_cpuexc_raise(excno);
	ttsp_mp_wait_check_point(prcid, 13);

	ttsp_mp_check_point(prcid, 14);
}

void ttsp_test_lib_init(intptr_t exinf){
	ttsp_initialize_test_lib();
}
