/*
 *  TTSP
 *      TOPPERS Test Suite Package
 * 
 *  Copyright (C) 2010-2012 by Center for Embedded Computing Systems
 *              Graduate School of Information Science, Nagoya Univ., JAPAN
 *  Copyright (C) 2010-2011 by Digital Craft Inc.
 *  Copyright (C) 2010-2011 by NEC Communication Systems, Ltd.
 *  Copyright (C) 2010-2012 by FUJISOFT INCORPORATED
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

/* ����ߤ�ȯ��������Ƚ�̤��뤿��Υե饰 */
bool_t int_flag[4];

typedef struct{
	ID almid;
	ID cycid;
	EXCNO excno;
	INTNO intno_a;
	INTNO intno_b;
	INTNO intno_c;
}PRC_INFO;

PRC_INFO prc_info[] = {
#ifdef TTSP_INTNO_B
#ifdef TTSP_INTNO_C
	{ALM1, CYC1, TTSP_EXCNO_A, TTSP_INTNO_A, TTSP_INTNO_B, TTSP_INTNO_C},
#else
	{ALM1, CYC1, TTSP_EXCNO_A, TTSP_INTNO_A, TTSP_INTNO_B, TTSP_INVALID_INTNO},
#endif /* TTSP_INTNO_C */
#else
	{ALM1, CYC1, TTSP_EXCNO_A, TTSP_INTNO_A, TTSP_INVALID_INTNO, TTSP_INVALID_INTNO},
#endif /* TTSP_INTNO_B */

#if TNUM_PRCID >= 2
#ifdef TTSP_INTNO_PE2_B
#ifdef TTSP_INTNO_PE2_C
	{ALM2, CYC2, TTSP_EXCNO_PE2_A, TTSP_INTNO_PE2_A, TTSP_INTNO_PE2_B, TTSP_INTNO_PE2_C},
#else
	{ALM2, CYC2, TTSP_EXCNO_PE2_A, TTSP_INTNO_PE2_A, TTSP_INTNO_PE2_B, TTSP_INVALID_INTNO},
#endif /* TTSP_INTNO_PE2_C */
#else
	{ALM2, CYC2, TTSP_EXCNO_PE2_A, TTSP_INTNO_PE2_A, TTSP_INVALID_INTNO, TTSP_INVALID_INTNO},
#endif /* TTSP_INTNO_PE2_B */
#endif /* TNUM_PRCID >= 2 */

#if TNUM_PRCID >= 3
#ifdef TTSP_INTNO_PE3_B
#ifdef TTSP_INTNO_PE3_C
	{ALM3, CYC3, TTSP_EXCNO_PE3_A, TTSP_INTNO_PE3_A, TTSP_INTNO_PE3_B, TTSP_INTNO_PE3_C},
#else
	{ALM3, CYC3, TTSP_EXCNO_PE3_A, TTSP_INTNO_PE3_A, TTSP_INTNO_PE3_B, TTSP_INVALID_INTNO},
#endif /* TTSP_INTNO_PE3_C */
#else
	{ALM3, CYC3, TTSP_EXCNO_PE3_A, TTSP_INTNO_PE3_A, TTSP_INVALID_INTNO, TTSP_INVALID_INTNO},
#endif /* TTSP_INTNO_PE3_B */
#endif /* TNUM_PRCID >= 3 */

#if TNUM_PRCID >= 4
#ifdef TTSP_INTNO_PE4_B
#ifdef TTSP_INTNO_PE4_C
	{ALM4, CYC4, TTSP_EXCNO_PE4_A, TTSP_INTNO_PE4_A, TTSP_INTNO_PE4_B, TTSP_INTNO_PE4_C}
#else
	{ALM4, CYC4, TTSP_EXCNO_PE4_A, TTSP_INTNO_PE4_A, TTSP_INTNO_PE4_B, TTSP_INVALID_INTNO}
#endif /* TTSP_INTNO_PE4_C */
#else
	{ALM4, CYC4, TTSP_EXCNO_PE4_A, TTSP_INTNO_PE4_A, TTSP_INVALID_INTNO, TTSP_INVALID_INTNO}
#endif /* TTSP_INTNO_PE4_B */
#endif /* TNUM_PRCID >= 4 */
};

void main_task(intptr_t exinf) {
	SIL_PRE_LOC;
	uint_t i;
	ER ercd;
	ID prcid = (ID)exinf;
	ID almid = prc_info[prcid - 1].almid;
	ID cycid = prc_info[prcid - 1].cycid;
	EXCNO excno = prc_info[prcid - 1].excno;
	INTNO intno_b = prc_info[prcid - 1].intno_b;
	INTNO intno_c = prc_info[prcid - 1].intno_c;
	i = 0;

	/* ������롼�������ȯ������������ߤ��Ԥ� */
	wait_raise_int(prcid);

	ttsp_mp_check_point(prcid, 1);

	/* 
	 * ������
	 */
	syslog_1(LOG_NOTICE, "PE %d : === test start from TASK ===", prcid);
	all_test(prcid, true);
	all_test(prcid, false);
	ttsp_mp_check_point(prcid, 2);

	ttsp_barrier_sync(1, TNUM_PRCID);

	/* 
	 * �������㳰�����롼����
	 */
	syslog_1(LOG_NOTICE, "PE %d : === test start from TASK EXPECT ===", prcid);
	ercd = ena_tex();
	check_ercd(ercd, E_OK);
	ercd = ras_tex(TSK_SELF, 0x00000001);
	check_ercd(ercd, E_OK);
	ttsp_mp_check_point(prcid, 4);
	ercd = dis_tex();
	check_ercd(ercd, E_OK);

	ttsp_barrier_sync(2, TNUM_PRCID);

#ifdef TOPPERS_SYSTIM_GLOBAL
	if (TOPPERS_SYSTIM_PRCID == prcid) {
#endif /* TOPPERS_SYSTIM_GLOBAL */

	/* 
	 * ���顼��ϥ�ɥ�
	 */
	syslog_1(LOG_NOTICE, "PE %d : === test start from ALARM ===", prcid);
	ercd = sta_alm(almid, 0);
	check_ercd(ercd, E_OK);
	ttsp_mp_wait_check_point(prcid, 5);
	ttsp_mp_check_point(prcid, 6);

	/* [e][k]�ǥ����ѥå��ػ߾��� */
	ercd = dis_dsp();
	check_ercd(ercd, E_OK);
	ercd = sta_alm(almid, 0);
	check_ercd(ercd, E_OK);
	ttsp_mp_wait_check_point(prcid, 7);
	ercd = ena_dsp();
	check_ercd(ercd, E_OK);
	ttsp_mp_check_point(prcid, 8);

	ttsp_barrier_sync(3, TNUM_PRCID);

	/* 
	 * �����ϥ�ɥ�
	 */
	syslog_1(LOG_NOTICE, "PE %d : === test start from CYCLIC ===", prcid);
	ercd = sta_cyc(cycid);
	check_ercd(ercd, E_OK);
	ttsp_mp_wait_check_point(prcid, 9);
	ercd = stp_cyc(cycid);
	check_ercd(ercd, E_OK);
	ttsp_mp_check_point(prcid, 10);

	/* [e][k]�ǥ����ѥå��ػ߾��� */
	ercd = dis_dsp();
	check_ercd(ercd, E_OK);
	ercd = sta_cyc(cycid);
	check_ercd(ercd, E_OK);
	ttsp_mp_wait_check_point(prcid, 11);
	ercd = stp_cyc(cycid);
	check_ercd(ercd, E_OK);
	ercd = ena_dsp();
	check_ercd(ercd, E_OK);
	ttsp_mp_check_point(prcid, 12);

	ttsp_barrier_sync(4, TNUM_PRCID);

#ifdef TOPPERS_SYSTIM_GLOBAL
	}
	if (TOPPERS_SYSTIM_PRCID != prcid) {
		/* �ХꥢƱ���������ॢ���Ȥ��ʤ��褦������ٱ������� */
		sil_dly_nse(TTSP_WAIT_NOT_RAISE_INT * 15);
		ttsp_barrier_sync(3, TNUM_PRCID);

		sil_dly_nse(TTSP_WAIT_NOT_RAISE_INT * 15);
		ttsp_barrier_sync(4, TNUM_PRCID);

		for (i = 5; i <= 12; i++) {
			ttsp_mp_check_point(prcid, i);
		}
	}
#endif /* TOPPERS_SYSTIM_GLOBAL */

	/* 
	 * CPU�㳰�ϥ�ɥ�
	 */
	syslog_1(LOG_NOTICE, "PE %d : === test start from EXCEPTION ===", prcid);
	ttsp_cpuexc_raise(excno);
	ttsp_mp_wait_check_point(prcid, 13);
	ttsp_mp_check_point(prcid, 14);

	/* [d][j]�����ͥ���٥ޥ���������Ǥʤ����� */
	ercd = chg_ipm(-1);
	check_ercd(ercd, E_OK);
	ttsp_cpuexc_raise(excno);
	ttsp_mp_wait_check_point(prcid, 15);
	ercd = chg_ipm(TIPM_ENAALL);
	check_ercd(ercd, E_OK);
	ttsp_mp_check_point(prcid, 16);

	/* [e][k]�ǥ����ѥå��ػ߾��� */
	ercd = dis_dsp();
	check_ercd(ercd, E_OK);
	ttsp_cpuexc_raise(excno);
	ttsp_mp_wait_check_point(prcid, 17);
	ercd = ena_dsp();
	check_ercd(ercd, E_OK);
	ttsp_mp_check_point(prcid, 18);

	ttsp_barrier_sync(5, TNUM_PRCID);

	if (intno_b != TTSP_INVALID_INTNO) {
		/* 
		 * ����ߥϥ�ɥ�
		 */
		syslog_1(LOG_NOTICE, "PE %d : === test start from INTHDR ===", prcid);
		ttsp_int_raise(intno_b);
		ttsp_mp_wait_check_point(prcid, 19);
		ttsp_mp_check_point(prcid, 20);

		/* [e][k]�ǥ����ѥå��ػ߾��� */
		ercd = dis_dsp();
		check_ercd(ercd, E_OK);
		ttsp_int_raise(intno_b);
		ttsp_mp_wait_check_point(prcid, 21);
		ercd = ena_dsp();
		check_ercd(ercd, E_OK);
		ttsp_mp_check_point(prcid, 22);
	} else {
		sil_dly_nse(TTSP_WAIT_NOT_RAISE_INT * 15);
		ttsp_mp_check_point(prcid, 19);
		ttsp_mp_check_point(prcid, 20);
		ttsp_mp_check_point(prcid, 21);
		ttsp_mp_check_point(prcid, 22);
	}

	ttsp_barrier_sync(6, TNUM_PRCID);

	if (intno_c != TTSP_INVALID_INTNO) {
		/* 
		 * ����ߥ����ӥ��롼����
		 */
		syslog_1(LOG_NOTICE, "PE %d : === test start from ISR ===", prcid);
		ttsp_int_raise(intno_c);
		ttsp_mp_wait_check_point(prcid, 23);
		ttsp_mp_check_point(prcid, 24);

		/* [e][k]�ǥ����ѥå��ػ߾��� */
		ercd = dis_dsp();
		check_ercd(ercd, E_OK);
		ttsp_int_raise(intno_c);
		ttsp_mp_wait_check_point(prcid, 25);
		ercd = ena_dsp();
		check_ercd(ercd, E_OK);
		ttsp_mp_check_point(prcid, 26);
	} else {
		sil_dly_nse(TTSP_WAIT_NOT_RAISE_INT * 15);
	}

	ttsp_barrier_sync(7, TNUM_PRCID);

	/* SIL���ԥ��å����֤�ext_ker��ȯ�ԤǤ��뤳�Ȥγ�ǧ */
	if (TOPPERS_MASTER_PRCID == prcid) {
		SIL_LOC_SPN();
		ext_ker();
	}
}

void texhdr(TEXPTN texptn, intptr_t exinf) {
	ID prcid = (ID)exinf;

	ttsp_mp_check_point(prcid, 3);
	all_test(prcid, true);
	all_test(prcid, false);
}

void almhdr(intptr_t exinf) {
	ID prcid = (ID)exinf;
	static int bootcnt[4] = {0};

	bootcnt[prcid - 1]++;

	if (bootcnt[prcid - 1] == 1) {
		ttsp_mp_check_point(prcid, 5);
		all_test(prcid, true);
		all_test(prcid, false);
	}
	if (bootcnt[prcid - 1] == 2) {
		ttsp_mp_check_point(prcid, 7);
		part_test(prcid, DIS_DSP, true);
		part_test(prcid, DIS_DSP, false);
	}
}

void cychdr(intptr_t exinf) {
	ID prcid = (ID)exinf;
	static int bootcnt[4] = {0};

	bootcnt[prcid - 1]++;

	if (bootcnt[prcid - 1] == 1) {
		ttsp_mp_check_point(prcid, 9);
		all_test(prcid, true);
		all_test(prcid, false);
	}
	if (bootcnt[prcid - 1] == 2) {
		ttsp_mp_check_point(prcid, 11);
		part_test(prcid, DIS_DSP, true);
		part_test(prcid, DIS_DSP, false);
	}
}

void inirtn(intptr_t exinf) {
	ID prcid = (ID)exinf;

	syslog_1(LOG_NOTICE, "PE %d : === test start from INIRTN ===", prcid);

	/*�֥�����֥��������ؿ��פγ�ǧ */
	test_of_sil_mem(prcid, false);

	/* ��sns_ker()ȯ�ԡפγ�ǧ */
	test_of_sns_ker(prcid, sns_ker(), false);

	/* �֥ץ��å�ID�λ��ȡפγ�ǧ */
	test_of_sil_get_pid(prcid, false);

	/* [a]�̾���� */
	test_of_SIL_LOC_INT_SPN(prcid, true);
	syslog_1(LOG_NOTICE, "PE %d : test_of_SIL_LOC_INT_SPN() [a-1]: OK", prcid);
	test_of_SIL_LOC_INT_SPN(prcid, false);
	syslog_1(LOG_NOTICE, "PE %d : test_of_SIL_LOC_INT_SPN() [a-3]: OK", prcid);
}

void terrtn(intptr_t exinf) {
	bool_t state;
	ID prcid = (ID)exinf;

	/* ���顼��ȯ�����Ƥ�����Ͻ�λ�롼�����¹Ԥ��ʤ� */
	state = ttsp_get_cp_state();
	if (state == false) {
		return;
	};

	syslog_1(LOG_NOTICE, "PE %d : === test start from TERRTN ===", prcid);

	/*�֥�����֥��������ؿ��פγ�ǧ */
	test_of_sil_mem(prcid, true);

	/* ��sns_ker()ȯ�ԡפγ�ǧ */
	test_of_sns_ker(prcid, sns_ker(), true);

	/* �֥ץ��å�ID�λ��ȡפγ�ǧ */
	test_of_sil_get_pid(prcid, true);

	/* [a]�̾���� */
	/* (ext_ker����SIL_LOC_SPN��ȯ�Ԥ��Ƥ��뤿��SIL_LOC_SPN�ϥƥ����Բ�) */
	test_of_SIL_LOC_INT_SPN(prcid, true);
	syslog_1(LOG_NOTICE, "PE %d : test_of_SIL_LOC_INT_SPN() [a-1]: OK", prcid);

	/* ���ץ��å������ｪλ���ԤĤ���˥ХꥢƱ������ */
	ttsp_barrier_sync(8, TNUM_PRCID);

	/* ���٤����ｪλ�Ǥ���Х�å�����ɽ�� */
	state = ttsp_get_cp_state();
	if ((state == true) && (TOPPERS_MASTER_PRCID == prcid)) {
		syslog_1(LOG_NOTICE, "PE %d : All check points passed.", prcid);
	};
}

void exchdr(void* p_excinf) {
	ER ercd;
	ID prcid;
	EXCNO excno;
	static int bootcnt[4] = {0};

	ercd = iget_pid(&prcid);
	check_ercd(ercd, E_OK);

	bootcnt[prcid - 1]++;

	excno = prc_info[prcid - 1].excno;
	ttsp_cpuexc_hook(excno, p_excinf);

	if (bootcnt[prcid - 1] == 1) {
		ttsp_mp_check_point(prcid, 13);
		all_test(prcid, true);
		all_test(prcid, false);
	}
	if (bootcnt[prcid - 1] == 2) {
		ttsp_mp_check_point(prcid, 15);
		part_test(prcid, CHG_IPM, true);
		part_test(prcid, CHG_IPM, false);
	}
	if (bootcnt[prcid - 1] == 3) {
		ttsp_mp_check_point(prcid, 17);
		part_test(prcid, DIS_DSP, true);
		part_test(prcid, DIS_DSP, false);
	}
}

#if defined(TTSP_INTNO_B) || defined(TTSP_INTNO_PE2_B) || defined(TTSP_INTNO_PE3_B) || defined(TTSP_INTNO_PE4_B)
void inthdr(void) {
	ER ercd;
	ID prcid;
	INTNO intno_b;
	static int bootcnt[4] = {0};

	ercd = iget_pid(&prcid);
	check_ercd(ercd, E_OK);

	intno_b = prc_info[prcid - 1].intno_b;

	bootcnt[prcid - 1]++;

	i_begin_int(intno_b);
	ttsp_clear_int_req(intno_b);

	if (bootcnt[prcid - 1] == 1) {
		ttsp_mp_check_point(prcid, 19);
		all_test(prcid, true);
		all_test(prcid, false);
	}
	if (bootcnt[prcid - 1] == 2) {
		ttsp_mp_check_point(prcid, 21);
		part_test(prcid, DIS_DSP, true);
		part_test(prcid, DIS_DSP, false);
	}

	i_end_int(intno_b);
}
#endif /* defined(TTSP_INTNO_B) || defined(TTSP_INTNO_PE2_B) || defined(TTSP_INTNO_PE3_B) || defined(TTSP_INTNO_PE4_B) */

#if defined(TTSP_INTNO_C) || defined(TTSP_INTNO_PE2_C) || defined(TTSP_INTNO_PE3_C) || defined(TTSP_INTNO_PE4_C)
void isr(intptr_t exinf) {
	ID prcid = (ID)exinf;
	static int bootcnt[4] = {0};
	INTNO intno_c = prc_info[prcid - 1].intno_c;

	ttsp_clear_int_req(intno_c);

	bootcnt[prcid - 1]++;

	if (bootcnt[prcid - 1] == 1) {
		ttsp_mp_check_point(prcid, 23);
		all_test(prcid, true);
		all_test(prcid, false);
	}
	if (bootcnt[prcid - 1] == 2) {
		ttsp_mp_check_point(prcid, 25);
		part_test(prcid, DIS_DSP, true);
		part_test(prcid, DIS_DSP, false);
	}
}
#endif /* defined(TTSP_INTNO_C) || defined(TTSP_INTNO_PE2_C) || defined(TTSP_INTNO_PE3_C) || defined(TTSP_INTNO_PE4_C) */

void all_test(ID prcid, bool_t int_spn_flg) {
	ER ercd;
	uint_t code;

	if (int_spn_flg == true) {
		code = 1;
	} else {
		code = 3;
	}

	if (int_spn_flg == true) {
		/*�����������Ԥ��פγ�ǧ */
#ifdef TOPPERS_SYSTIM_GLOBAL
		if (TOPPERS_SYSTIM_PRCID == prcid) {
#endif /* TOPPERS_SYSTIM_GLOBAL */
		if (!(sns_ctx())) {
			test_of_sil_dly_nse(prcid);
		}
#ifdef TOPPERS_SYSTIM_GLOBAL
		}
#endif /* TOPPERS_SYSTIM_GLOBAL */

		/*�֥�����֥��������ؿ��פγ�ǧ */
		test_of_sil_mem(prcid, false);

		/* �֥ץ��å�ID�λ��ȡפγ�ǧ */
		test_of_sil_get_pid(prcid, false);

		/* ��sns_ker()ȯ�ԡפγ�ǧ */
		test_of_sns_ker(prcid, sns_ker(), false);
	}

	/*
	 * ��������ߥ�å����֤�����פγ�ǧ
	 */

	/* �������˥ͥ��Ȥ��ʤ��ƥ��� */

	/* [a]�̾���� */
	test_of_SIL_LOC_INT_SPN(prcid, int_spn_flg);
	wait_raise_int(prcid);
	syslog_2(LOG_NOTICE, "PE %d : test_of_SIL_LOC_INT_SPN() [a-%d]: OK", prcid, code);

	/* [b]������ߥ�å����� */
	{
		SIL_PRE_LOC;
		SIL_LOC_INT();
		test_of_SIL_LOC_INT_SPN(prcid, int_spn_flg);
		SIL_UNL_INT();
	}
	wait_raise_int(prcid);
	syslog_2(LOG_NOTICE, "PE %d : test_of_SIL_LOC_INT_SPN() [b-%d]: OK", prcid, code);

	/* [c]CPU��å����� */
	if (sns_ctx()) {
		ercd = iloc_cpu();
	} else {
		ercd = loc_cpu();
	}
	check_ercd(ercd, E_OK);
	test_of_SIL_LOC_INT_SPN(prcid, int_spn_flg);
	if (sns_ctx()) {
		ercd = iunl_cpu();
	} else {
		ercd = unl_cpu();
	}
	check_ercd(ercd, E_OK);
	wait_raise_int(prcid);
	syslog_2(LOG_NOTICE, "PE %d : test_of_SIL_LOC_INT_SPN() [c-%d]: OK", prcid, code);

	/* [d]�����ͥ���٥ޥ���������Ǥʤ����� */
	if (!(sns_ctx())) {
		ercd = chg_ipm(-1);
		check_ercd(ercd, E_OK);
		test_of_SIL_LOC_INT_SPN(prcid, int_spn_flg);
		ercd = chg_ipm(TIPM_ENAALL);
		check_ercd(ercd, E_OK);
		wait_raise_int(prcid);
		syslog_2(LOG_NOTICE, "PE %d : test_of_SIL_LOC_INT_SPN() [d-%d]: OK", prcid, code);
	}

	/* [e]�ǥ����ѥå��ػ߾��� */
	if (!(sns_ctx())) {
		ercd = dis_dsp();
		check_ercd(ercd, E_OK);
		test_of_SIL_LOC_INT_SPN(prcid, int_spn_flg);
		ercd = ena_dsp();
		check_ercd(ercd, E_OK);
		wait_raise_int(prcid);
		syslog_2(LOG_NOTICE, "PE %d : test_of_SIL_LOC_INT_SPN() [e-%d]: OK", prcid, code);
	}

	/* [f]SIL���ԥ��å����� */
	if (int_spn_flg == true) {
		{
			SIL_PRE_LOC;
			SIL_LOC_SPN();
			test_of_SIL_LOC_INT_SPN(prcid, int_spn_flg);
			SIL_UNL_SPN();
		}
		wait_raise_int(prcid);
		syslog_2(LOG_NOTICE, "PE %d : test_of_SIL_LOC_INT_SPN() [f-%d]: OK", prcid, code);
	}

	/* [g]API���ԥ��å����� */
	if (sns_ctx()) {
		ercd = iloc_spn(SPN_ALL);
	} else {
		ercd = loc_spn(SPN_ALL);
	}
	check_ercd(ercd, E_OK);
	test_of_SIL_LOC_INT_SPN(prcid, int_spn_flg);
	if (sns_ctx()) {
		ercd = iunl_spn(SPN_ALL);
	} else {
		ercd = unl_spn(SPN_ALL);
	}
	check_ercd(ercd, E_OK);
	wait_raise_int(prcid);
	syslog_2(LOG_NOTICE, "PE %d : test_of_SIL_LOC_INT_SPN() [g-%d]: OK", prcid, code);

	/* �������˥ͥ��Ȥ�¸�ߤ���ƥ��� */

	/* [h]SIL_LOC_INT() �� SIL_LOC_INT/SPN() */
	{
		SIL_PRE_LOC;
		SIL_LOC_INT();
		{
			SIL_PRE_LOC;
			SIL_LOC_INT();
			test_of_SIL_LOC_INT_SPN(prcid, int_spn_flg);
			SIL_UNL_INT();
		}
		SIL_UNL_INT();
	}
	wait_raise_int(prcid);
	syslog_2(LOG_NOTICE, "PE %d : test_of_SIL_LOC_INT_SPN() [h-%d]: OK", prcid, code);

	/* [i]loc_cpu()/iloc_cpu() �� SIL_LOC_INT/SPN() */
	if (sns_ctx()) {
		ercd = iloc_cpu();
	} else {
		ercd = loc_cpu();
	}
	check_ercd(ercd, E_OK);
	{
		SIL_PRE_LOC;
		SIL_LOC_INT();
		test_of_SIL_LOC_INT_SPN(prcid, int_spn_flg);
		SIL_UNL_INT();
	}
	if (sns_ctx()) {
		ercd = iunl_cpu();
	} else {
		ercd = unl_cpu();
	}
	check_ercd(ercd, E_OK);
	wait_raise_int(prcid);
	syslog_2(LOG_NOTICE, "PE %d : test_of_SIL_LOC_INT_SPN() [i-%d]: OK", prcid, code);

	/* [j]chg_ipm(-1) �� SIL_LOC_INT/SPN() */
	if (!(sns_ctx())) {
		ercd = chg_ipm(-1);
		check_ercd(ercd, E_OK);
		{
			SIL_PRE_LOC;
			SIL_LOC_INT();
			test_of_SIL_LOC_INT_SPN(prcid, int_spn_flg);
			SIL_UNL_INT();
		}
		ercd = chg_ipm(TIPM_ENAALL);
		check_ercd(ercd, E_OK);
		wait_raise_int(prcid);
		syslog_2(LOG_NOTICE, "PE %d : test_of_SIL_LOC_INT_SPN() [j-%d]: OK", prcid, code);
	}

	/* [k]dis_dsp() �� SIL_LOC_INT/SPN() */
	if (!(sns_ctx())) {
		ercd = dis_dsp();
		check_ercd(ercd, E_OK);
		{
			SIL_PRE_LOC;
			SIL_LOC_INT();
			test_of_SIL_LOC_INT_SPN(prcid, int_spn_flg);
			SIL_UNL_INT();
		}
		ercd = ena_dsp();
		check_ercd(ercd, E_OK);
		wait_raise_int(prcid);
		syslog_2(LOG_NOTICE, "PE %d : test_of_SIL_LOC_INT_SPN() [k-%d]: OK", prcid, code);
	}

	if (int_spn_flg == true) {
		/* [l]SIL_LOC_INT() �� SIL_LOC_SPN() �� SIL_LOC_INT() */
		{
			SIL_PRE_LOC;
			SIL_LOC_INT();
			{
				SIL_PRE_LOC;
				SIL_LOC_SPN();
				test_of_SIL_LOC_INT_SPN(prcid, int_spn_flg);
				SIL_UNL_SPN();
			}
			SIL_UNL_INT();
		}
		wait_raise_int(prcid);
		syslog_2(LOG_NOTICE, "PE %d : test_of_SIL_LOC_INT_SPN() [l-%d]: OK", prcid, code);

		/* [m]SIL_LOC_SPN() �� SIL_LOC_INT() �� SIL_LOC_INT() */
		{
			SIL_PRE_LOC;
			SIL_LOC_SPN();
			{
				SIL_PRE_LOC;
				SIL_LOC_INT();
				test_of_SIL_LOC_INT_SPN(prcid, int_spn_flg);
				SIL_UNL_INT();
			}
			SIL_UNL_SPN();
		}
		wait_raise_int(prcid);
		syslog_2(LOG_NOTICE, "PE %d : test_of_SIL_LOC_INT_SPN() [m-%d]: OK", prcid, code);

		/* [n]loc_cpu()/iloc_cpu() �� SIL_LOC_SPN() �� SIL_LOC_INT() */
		if (sns_ctx()) {
			ercd = iloc_cpu();
		} else {
			ercd = loc_cpu();
		}
		check_ercd(ercd, E_OK);
		{
			SIL_PRE_LOC;
			SIL_LOC_SPN();
			test_of_SIL_LOC_INT_SPN(prcid, int_spn_flg);
			SIL_UNL_SPN();
		}
		if (sns_ctx()) {
			ercd = iunl_cpu();
		} else {
			ercd = unl_cpu();
		}
		check_ercd(ercd, E_OK);
		wait_raise_int(prcid);
		syslog_2(LOG_NOTICE, "PE %d : test_of_SIL_LOC_INT_SPN() [n-%d]: OK", prcid, code);

		/* [o]chg_ipm(-1) �� SIL_LOC_SPN() �� SIL_LOC_INT() */
		if (!(sns_ctx())) {
			ercd = chg_ipm(-1);
			check_ercd(ercd, E_OK);
			{
				SIL_PRE_LOC;
				SIL_LOC_SPN();
				test_of_SIL_LOC_INT_SPN(prcid, int_spn_flg);
				SIL_UNL_SPN();
			}
			ercd = chg_ipm(TIPM_ENAALL);
			check_ercd(ercd, E_OK);
			wait_raise_int(prcid);
			syslog_2(LOG_NOTICE, "PE %d : test_of_SIL_LOC_INT_SPN() [o-%d]: OK", prcid, code);
		}

		/* [p]dis_dsp() �� SIL_LOC_SPN() �� SIL_LOC_INT() */
		if (!(sns_ctx())) {
			ercd = dis_dsp();
			check_ercd(ercd, E_OK);
			{
				SIL_PRE_LOC;
				SIL_LOC_SPN();
				test_of_SIL_LOC_INT_SPN(prcid, int_spn_flg);
				SIL_UNL_SPN();
			}
			ercd = ena_dsp();
			check_ercd(ercd, E_OK);
			wait_raise_int(prcid);
			syslog_2(LOG_NOTICE, "PE %d : test_of_SIL_LOC_INT_SPN() [p-%d]: OK", prcid, code);
		}

		/* [q]loc_spn/iloc_spn() �� SIL_LOC_SPN() �� SIL_LOC_INT() */
		if (sns_ctx()) {
			ercd = iloc_spn(SPN_ALL);
		} else {
			ercd = loc_spn(SPN_ALL);
		}
		check_ercd(ercd, E_OK);
		{
			SIL_PRE_LOC;
			SIL_LOC_SPN();
			test_of_SIL_LOC_INT_SPN(prcid, int_spn_flg);
			SIL_UNL_SPN();
		}
		if (sns_ctx()) {
			ercd = iunl_spn(SPN_ALL);
		} else {
			ercd = unl_spn(SPN_ALL);
		}
		check_ercd(ercd, E_OK);
		wait_raise_int(prcid);
		syslog_2(LOG_NOTICE, "PE %d : test_of_SIL_LOC_INT_SPN() [q-%d]: OK", prcid, code);
	}
}

void part_test(ID prcid, E_TEST_TYPE test_type, bool_t int_spn_flg) {
	uint_t code;

	if (int_spn_flg == true) {
		code = 1;
	} else {
		code = 3;
	}

	/* [d]�����ͥ���٥ޥ���������Ǥʤ����� */
	/* [e]�ǥ����ѥå��ػ߾��� */
	test_of_SIL_LOC_INT_SPN(prcid, int_spn_flg);
	wait_raise_int(prcid);
	if (test_type == CHG_IPM) {
		syslog_2(LOG_NOTICE, "PE %d : test_of_SIL_LOC_INT_SPN() [d-%d]: OK", prcid, code);
	}
	else if (test_type == DIS_DSP) {
		syslog_2(LOG_NOTICE, "PE %d : test_of_SIL_LOC_INT_SPN() [e-%d]: OK", prcid, code);
	}

	/* [j]chg_ipm(-1) �� SIL_LOC_INT() */
	/* [k]dis_dsp() �� SIL_LOC_INT() */
	{
		SIL_PRE_LOC;
		SIL_LOC_INT();
		test_of_SIL_LOC_INT_SPN(prcid, int_spn_flg);
		SIL_UNL_INT();
	}
	wait_raise_int(prcid);
	if (test_type == CHG_IPM) {
		syslog_2(LOG_NOTICE, "PE %d : test_of_SIL_LOC_INT_SPN() [j-%d]: OK", prcid, code);
	}
	else if (test_type == DIS_DSP) {
		syslog_2(LOG_NOTICE, "PE %d : test_of_SIL_LOC_INT_SPN() [k-%d]: OK", prcid, code);
	}

	if (int_spn_flg == true) {
		/* [o]chg_ipm(-1) �� SIL_LOC_SPN() �� SIL_LOC_INT/SPN() */
		/* [p]dis_dsp() �� SIL_LOC_SPN() �� SIL_LOC_INT/SPN() */
		{
			SIL_PRE_LOC;
			SIL_LOC_SPN();
			test_of_SIL_LOC_INT_SPN(prcid, int_spn_flg);
			SIL_UNL_SPN();
		}
		wait_raise_int(prcid);
		if (test_type == CHG_IPM) {
			syslog_2(LOG_NOTICE, "PE %d : test_of_SIL_LOC_INT_SPN() [o-%d]: OK", prcid, code);
		}
		else if (test_type == DIS_DSP) {
			syslog_2(LOG_NOTICE, "PE %d : test_of_SIL_LOC_INT_SPN() [p-%d]: OK", prcid, code);
		}
	}
}

void inthdr_for_int_test(void) {
	ER ercd;
	ID prcid;
	INTNO intno_a;

	ercd = iget_pid(&prcid);
	check_ercd(ercd, E_OK);

	intno_a = prc_info[prcid - 1].intno_a;

	i_begin_int(intno_a);
	ttsp_clear_int_req(intno_a);

	/* ����ߤ����ä����Ȥ����� */
	int_flag[prcid - 1] = true;

	i_end_int(intno_a);
}

void test_of_sil_dly_nse(ID prcid) {
	ER ercd;
	SYSTIM system1, system2;

	ercd = get_tim(&system1);
	check_ercd(ercd, E_OK);
	sil_dly_nse(SIL_DLY_TIME);
	ercd = get_tim(&system2);
	check_ercd(ercd, E_OK);
	check_assert((system2 - system1) >= SIL_DLY_TIME_SUB);

	syslog_1(LOG_NOTICE, "PE %d : test_of_sil_dly_nse()          : OK", prcid);
}

void test_of_sil_mem(ID prcid, bool_t ter_flg) {
	check_of_sil_mem();

	{
		SIL_PRE_LOC;
		SIL_LOC_INT();
		check_of_sil_mem();
		SIL_UNL_INT();
	}

	/* ��λ�롼�����SIL_LOC_SPN���ͥ��Ȥ��Ƥ��ޤ�����»��Բ� */
	if (ter_flg == false) {
		{
			SIL_PRE_LOC;
			SIL_LOC_SPN();
			check_of_sil_mem();
			SIL_UNL_SPN();
		}
	}

	syslog_1(LOG_NOTICE, "PE %d : test_of_sil_mem()              : OK", prcid);
}

void test_of_sil_get_pid(ID prcid, bool_t ter_flg) {
	ID sil_prcid;

	sil_get_pid(&sil_prcid);
	check_assert(sil_prcid == prcid);

	{
		SIL_PRE_LOC;
		SIL_LOC_INT();
		sil_get_pid(&sil_prcid);
		check_assert(sil_prcid == prcid);
		SIL_UNL_INT();
	}

	/* ��λ�롼�����SIL_LOC_SPN���ͥ��Ȥ��Ƥ��ޤ�����»��Բ� */
	if (ter_flg == false) {
		{
			SIL_PRE_LOC;
			SIL_LOC_SPN();
			sil_get_pid(&sil_prcid);
			check_assert(sil_prcid == prcid);
			SIL_UNL_SPN();
		}
	}

	syslog_1(LOG_NOTICE, "PE %d : test_of_sil_get_pid()          : OK", prcid);
}

void test_of_sns_ker(ID prcid, bool_t flag, bool_t ter_flg) {
	bool_t state;

	state = sns_ker();
	check_assert(state == flag);

	{
		SIL_PRE_LOC;
		SIL_LOC_INT();
		state = sns_ker();
		check_assert(state == flag);
		SIL_UNL_INT();
	}

	/* ��λ�롼�����SIL_LOC_SPN���ͥ��Ȥ��Ƥ��ޤ�����»��Բ� */
	if (ter_flg == false) {
		{
			SIL_PRE_LOC;
			SIL_LOC_SPN();
			state = sns_ker();
			check_assert(state == flag);
			SIL_UNL_SPN();
		}
	}

	syslog_1(LOG_NOTICE, "PE %d : test_of_sns_ker()              : OK", prcid);
}

void test_of_SIL_LOC_INT_SPN(ID prcid, bool_t int_spn_flg) {
	SIL_PRE_LOC;

	INTNO intno_a = prc_info[prcid - 1].intno_a;

	/* �ե饰����� */
	int_flag[prcid - 1] = false;

	/* �ƥ����оݤ�SIL�ؿ�ȯ�� */
	if (int_spn_flg == true) {
		SIL_LOC_INT();
	} else {
		SIL_LOC_SPN();
	}

	/* ����ߤ�ȯ�� */
	ttsp_int_raise(intno_a);

	/* ����ߤ�ȯ�����ʤ����Ȥ��Ԥ� */
	sil_dly_nse(TTSP_WAIT_NOT_RAISE_INT);

	/* �ե饰����������Ƥ��ʤ����Ȥ��ǧ */
	check_assert(int_flag[prcid - 1] == false);

	/* ���ξ��֤��᤹ */
	/* (b-2/f-4/h-2/i-2/j-2/k-2/l-4/n-4/o-4/p-4/q-4�Υƥ��Ȥ��ͤ�) */
	if (int_spn_flg == true) {
		SIL_UNL_INT();
	} else {
		SIL_UNL_SPN();
	}
}

void wait_raise_int(ID prcid) {
	ulong_t timeout = 0;

	/* ����ߤ�ȯ������Τ��Ԥ� */
	while (int_flag[prcid - 1] == false) {
		timeout++;
		if (timeout > TTSP_LOOP_COUNT) {
			syslog_1(LOG_ERROR, "## PE %d : wait_raise_int() caused a timeout.", prcid);
			ttsp_set_cp_state(false);
			ext_ker();
		}
		sil_dly_nse(TTSP_SIL_DLY_NSE_TIME);
	}
}

void check_of_sil_mem(void) {
	uint8_t   r8_data  = R_DATA8;
	uint16_t  r16_data = R_DATA16;
	uint32_t  r32_data = R_DATA32;
	uint8_t   w8_data  = W_DATA8;
	uint16_t  w16_data = W_DATA16;
	uint32_t  w32_data = W_DATA32;
	uint8_t   w8_temp  = CLEAR32;
	uint16_t  w16_temp = CLEAR32;
	uint32_t  w32_temp = CLEAR32;

	/* 8bit ������֥��������ؿ� */
	w8_temp = sil_reb_mem((void*)&r8_data);
	check_assert(w8_temp == R_DATA8);
	w8_temp = CLEAR32;

	sil_wrb_mem((void*)&w8_temp, w8_data);
	check_assert(w8_temp == W_DATA8);
	w8_temp = CLEAR32;

	/* 16bit ������֥��������ؿ� */
	w16_temp = sil_reh_mem((void*)&r16_data);
	check_assert(w16_temp == R_DATA16);
	w16_temp = CLEAR32;

	sil_wrh_mem((void*)&w16_temp, w16_data);
	check_assert(w16_temp == W_DATA16);
	w16_temp = CLEAR32;

#ifdef SIL_ENDIAN_LITTLE
	w16_temp = sil_reh_lem((void*)&r16_data);
#endif /* SIL_ENDIAN_LITTLE */
#ifdef SIL_ENDIAN_BIG
	w16_temp = sil_reh_bem((void*)&r16_data);
#endif /* SIL_ENDIAN_BIG */
	check_assert(w16_temp == R_DATA16);
	w16_temp = CLEAR32;

#ifdef SIL_ENDIAN_LITTLE
	sil_wrh_lem((void*)&w16_temp, w16_data);
#endif /* SIL_ENDIAN_LITTLE */
#ifdef SIL_ENDIAN_BIG
	sil_wrh_bem((void*)&w16_temp, w16_data);
#endif /* SIL_ENDIAN_BIG */
	check_assert(w16_temp == W_DATA16);
	w16_temp = CLEAR32;

	/* 32bit ������֥��������ؿ� */
	w32_temp = sil_rew_mem((void*)&r32_data);
	check_assert(w32_temp == R_DATA32);
	w32_temp = CLEAR32;

	sil_wrw_mem((void*)&w32_temp, w32_data);
	check_assert(w32_temp == W_DATA32);
	w32_temp = CLEAR32;

#ifdef SIL_ENDIAN_LITTLE
	w32_temp = sil_rew_lem((void*)&r32_data);
#endif /* SIL_ENDIAN_LITTLE */
#ifdef SIL_ENDIAN_BIG
	w32_temp = sil_rew_bem((void*)&r32_data);
#endif /* SIL_ENDIAN_BIG */
	check_assert(w32_temp == R_DATA32);
	w32_temp = CLEAR32;

#ifdef SIL_ENDIAN_LITTLE
	sil_wrw_lem((void*)&w32_temp, w32_data);
#endif /* SIL_ENDIAN_LITTLE */
#ifdef SIL_ENDIAN_BIG
	sil_wrw_bem((void*)&w32_temp, w32_data);
#endif /* SIL_ENDIAN_BIG */
	check_assert(w32_temp == W_DATA32);
	w32_temp = CLEAR32;
}

void ttsp_test_lib_init(intptr_t exinf){
	uint_t i;
	ttsp_initialize_test_lib();
	for (i = 0; i < TNUM_PRCID; i++) {
		int_flag[i] = false;
	}
}
