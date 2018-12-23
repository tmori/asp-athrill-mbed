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
bool_t int_flag;

void main_task(intptr_t exinf) {
	SIL_PRE_LOC;
	ER ercd;

	/* ������롼�������ȯ������������ߤ��Ԥ� */
	wait_raise_int();

	ttsp_check_point(1);

	/* 
	 * ������
	 */
	syslog_0(LOG_NOTICE, "=== test start from TASK ===");
	all_test();
	ttsp_check_point(2);


	/* 
	 * �������㳰�����롼����
	 */
	syslog_0(LOG_NOTICE, "=== test start from TASK EXPECT ===");
	ercd = ena_tex();
	check_ercd(ercd, E_OK);
	ercd = ras_tex(TSK_SELF, 0x00000001);
	check_ercd(ercd, E_OK);
	ttsp_check_point(4);
	ercd = dis_tex();
	check_ercd(ercd, E_OK);


	/* 
	 * ���顼��ϥ�ɥ�
	 */
	syslog_0(LOG_NOTICE, "=== test start from ALARM ===");
	ercd = sta_alm(ALM, 0);
	check_ercd(ercd, E_OK);
	ttsp_wait_check_point(5);
	ttsp_check_point(6);

	/* [e][k]�ǥ����ѥå��ػ߾��� */
	ercd = dis_dsp();
	check_ercd(ercd, E_OK);
	ercd = sta_alm(ALM, 0);
	check_ercd(ercd, E_OK);
	ttsp_wait_check_point(7);
	ercd = ena_dsp();
	check_ercd(ercd, E_OK);
	ttsp_check_point(8);


	/* 
	 * �����ϥ�ɥ�
	 */
	syslog_0(LOG_NOTICE, "=== test start from CYCLIC ===");
	ercd = sta_cyc(CYC);
	check_ercd(ercd, E_OK);
	ttsp_wait_check_point(9);
	ercd = stp_cyc(CYC);
	check_ercd(ercd, E_OK);
	ttsp_check_point(10);

	/* [e][k]�ǥ����ѥå��ػ߾��� */
	ercd = dis_dsp();
	check_ercd(ercd, E_OK);
	ercd = sta_cyc(CYC);
	check_ercd(ercd, E_OK);
	ttsp_wait_check_point(11);
	ercd = stp_cyc(CYC);
	check_ercd(ercd, E_OK);
	ercd = ena_dsp();
	check_ercd(ercd, E_OK);
	ttsp_check_point(12);


	/* 
	 * CPU�㳰�ϥ�ɥ�
	 */
	syslog_0(LOG_NOTICE, "=== test start from EXCEPTION ===");
	ttsp_cpuexc_raise(TTSP_EXCNO_A);
	ttsp_wait_check_point(13);
	ttsp_check_point(14);

	/* [d][j]�����ͥ���٥ޥ���������Ǥʤ����� */
	ercd = chg_ipm(-1);
	check_ercd(ercd, E_OK);
	ttsp_cpuexc_raise(TTSP_EXCNO_A);
	ttsp_wait_check_point(15);
	ercd = chg_ipm(TIPM_ENAALL);
	check_ercd(ercd, E_OK);
	ttsp_check_point(16);

	/* [e][k]�ǥ����ѥå��ػ߾��� */
	ercd = dis_dsp();
	check_ercd(ercd, E_OK);
	ttsp_cpuexc_raise(TTSP_EXCNO_A);
	ttsp_wait_check_point(17);
	ercd = ena_dsp();
	check_ercd(ercd, E_OK);
	ttsp_check_point(18);


#ifdef TTSP_INTNO_B
	/* 
	 * ����ߥϥ�ɥ�
	 */
	syslog_0(LOG_NOTICE, "=== test start from INTHDR ===");
	ttsp_int_raise(TTSP_INTNO_B);
	ttsp_wait_check_point(19);
	ttsp_check_point(20);

	/* [e][k]�ǥ����ѥå��ػ߾��� */
	ercd = dis_dsp();
	check_ercd(ercd, E_OK);
	ttsp_int_raise(TTSP_INTNO_B);
	ttsp_wait_check_point(21);
	ercd = ena_dsp();
	check_ercd(ercd, E_OK);
	ttsp_check_point(22);
#else
	ttsp_check_point(19);
	ttsp_check_point(20);
	ttsp_check_point(21);
	ttsp_check_point(22);
#endif /* TTSP_INTNO_B */


#ifdef TTSP_INTNO_C
	/* 
	 * ����ߥ����ӥ��롼����
	 */
	syslog_0(LOG_NOTICE, "=== test start from ISR ===");
	ttsp_int_raise(TTSP_INTNO_C);
	ttsp_wait_check_point(23);
	ttsp_check_point(24);

	/* [e][k]�ǥ����ѥå��ػ߾��� */
	ercd = dis_dsp();
	check_ercd(ercd, E_OK);
	ttsp_int_raise(TTSP_INTNO_C);
	ttsp_wait_check_point(25);
	ercd = ena_dsp();
	check_ercd(ercd, E_OK);
	ttsp_check_point(26);
#endif /* TTSP_INTNO_C */


	/* ������ߥ�å����֤�ext_ker��ȯ�ԤǤ��뤳�Ȥγ�ǧ */
	SIL_LOC_INT();
	ext_ker();
}

void texhdr(TEXPTN texptn, intptr_t exinf) {
	ttsp_check_point(3);
	all_test();
}

void almhdr(intptr_t exinf) {
	static int bootcnt = 0;

	bootcnt++;

	if (bootcnt == 1) {
		ttsp_check_point(5);
		all_test();
	}
	if (bootcnt == 2) {
		ttsp_check_point(7);
		part_test(DIS_DSP);
	}
}

void cychdr(intptr_t exinf) {
	static int bootcnt = 0;

	bootcnt++;

	if (bootcnt == 1) {
		ttsp_check_point(9);
		all_test();
	}
	if (bootcnt == 2) {
		ttsp_check_point(11);
		part_test(DIS_DSP);
	}
}

void inirtn(intptr_t exinf) {
	ttsp_initialize_test_lib();
	int_flag = false;

	syslog_0(LOG_NOTICE, "=== test start from INIRTN ===");

	/*�֥�����֥��������ؿ��פγ�ǧ */
	test_of_sil_mem();

	/* sns_ker()�γ�ǧ */
	test_of_sns_ker(sns_ker());

	/* [a]�̾���� */
	test_of_SIL_LOC_INT();
	syslog_0(LOG_NOTICE, "test_of_SIL_LOC_INT() [a]: OK");
}

void terrtn(intptr_t exinf) {
	bool_t state;

	/* ���顼��ȯ�����Ƥ�����Ͻ�λ�롼�����¹Ԥ��ʤ� */
	state = ttsp_get_cp_state();
	if (state == false) {
		return;
	};

	syslog_0(LOG_NOTICE, "=== test start from TERRTN ===");

	/*�֥�����֥��������ؿ��פγ�ǧ */
	test_of_sil_mem();

	/* sns_ker()�γ�ǧ */
	test_of_sns_ker(sns_ker());

	/* [a]�̾���� */
	test_of_SIL_LOC_INT();
	syslog_0(LOG_NOTICE, "test_of_SIL_LOC_INT() [a]: OK");

	/* ���٤����ｪλ�Ǥ���Х�å�����ɽ�� */
	state = ttsp_get_cp_state();
	if (state == true) {
		syslog_0(LOG_NOTICE, "All check points passed.");
	};
}

void exchdr(void* p_excinf) {
	static int bootcnt = 0;

	bootcnt++;

	ttsp_cpuexc_hook(TTSP_EXCNO_A, p_excinf);

	if (bootcnt == 1) {
		ttsp_check_point(13);
		all_test();
	}
	if (bootcnt == 2) {
		ttsp_check_point(15);
		part_test(CHG_IPM);
	}
	if (bootcnt == 3) {
		ttsp_check_point(17);
		part_test(DIS_DSP);
	}
}

#ifdef TTSP_INTNO_B
void inthdr(void) {
	static int bootcnt = 0;

	i_begin_int(TTSP_INTNO_B);
	ttsp_clear_int_req(TTSP_INTNO_B);

	bootcnt++;

	if (bootcnt == 1) {
		ttsp_check_point(19);
		all_test();
	}
	if (bootcnt == 2) {
		ttsp_check_point(21);
		part_test(DIS_DSP);
	}

	i_end_int(TTSP_INTNO_A);
}
#endif /* TTSP_INTNO_B */

#ifdef TTSP_INTNO_C
void isr(intptr_t exinf) {
	static int bootcnt = 0;

	ttsp_clear_int_req(TTSP_INTNO_C);

	bootcnt++;

	if (bootcnt == 1) {
		ttsp_check_point(23);
		all_test();
	}
	if (bootcnt == 2) {
		ttsp_check_point(25);
		part_test(DIS_DSP);
	}
}
#endif /* TTSP_INTNO_C */

void all_test(void) {
	ER ercd;

	/*�����������Ԥ��פγ�ǧ */
	if (!(sns_ctx())) {
		test_of_sil_dly_nse();
	}

	/*�֥�����֥��������ؿ��פγ�ǧ */
	test_of_sil_mem();

	/* ��sns_ker()ȯ�ԡפγ�ǧ */
	test_of_sns_ker(sns_ker());

	/*
	 * ��������ߥ�å����֤�����פγ�ǧ
	 */

	/* �������˥ͥ��Ȥ��ʤ��ƥ��� */

	/* [a]�̾���� */
	test_of_SIL_LOC_INT();
	wait_raise_int();
	syslog_0(LOG_NOTICE, "test_of_SIL_LOC_INT() [a]: OK");

	/* [b]������ߥ�å����� */
	{
		SIL_PRE_LOC;
		SIL_LOC_INT();
		test_of_SIL_LOC_INT();
		SIL_UNL_INT();
	}
	wait_raise_int();
	syslog_0(LOG_NOTICE, "test_of_SIL_LOC_INT() [b]: OK");

	/* [c]CPU��å����� */
	if (sns_ctx()) {
		ercd = iloc_cpu();
	} else {
		ercd = loc_cpu();
	}
	check_ercd(ercd, E_OK);
	test_of_SIL_LOC_INT();
	if (sns_ctx()) {
		ercd = iunl_cpu();
	} else {
		ercd = unl_cpu();
	}
	check_ercd(ercd, E_OK);
	wait_raise_int();
	syslog_0(LOG_NOTICE, "test_of_SIL_LOC_INT() [c]: OK");

	/* [d]�����ͥ���٥ޥ���������Ǥʤ����� */
	if (!(sns_ctx())) {
		ercd = chg_ipm(-1);
		check_ercd(ercd, E_OK);
		test_of_SIL_LOC_INT();
		ercd = chg_ipm(TIPM_ENAALL);
		check_ercd(ercd, E_OK);
		wait_raise_int();
		syslog_0(LOG_NOTICE, "test_of_SIL_LOC_INT() [d]: OK");
	}

	/* [e]�ǥ����ѥå��ػ߾��� */
	if (!(sns_ctx())) {
		ercd = dis_dsp();
		check_ercd(ercd, E_OK);
		test_of_SIL_LOC_INT();
		ercd = ena_dsp();
		check_ercd(ercd, E_OK);
		wait_raise_int();
		syslog_0(LOG_NOTICE, "test_of_SIL_LOC_INT() [e]: OK");
	}

	/* �������˥ͥ��Ȥ�¸�ߤ���ƥ��� */

	/* [h]SIL_LOC_INT() �� SIL_LOC_INT() */
	{
		SIL_PRE_LOC;
		SIL_LOC_INT();
		{
			SIL_PRE_LOC;
			SIL_LOC_INT();
			test_of_SIL_LOC_INT();
			SIL_UNL_INT();
		}
		SIL_UNL_INT();
	}
	wait_raise_int();
	syslog_0(LOG_NOTICE, "test_of_SIL_LOC_INT() [h]: OK");

	/* [i]loc_cpu()/iloc_cpu() �� SIL_LOC_INT() */
	if (sns_ctx()) {
		ercd = iloc_cpu();
	} else {
		ercd = loc_cpu();
	}
	check_ercd(ercd, E_OK);
	{
		SIL_PRE_LOC;
		SIL_LOC_INT();
		test_of_SIL_LOC_INT();
		SIL_UNL_INT();
	}
	if (sns_ctx()) {
		ercd = iunl_cpu();
	} else {
		ercd = unl_cpu();
	}
	check_ercd(ercd, E_OK);
	wait_raise_int();
	syslog_0(LOG_NOTICE, "test_of_SIL_LOC_INT() [i]: OK");

	/* [j]chg_ipm(-1) �� SIL_LOC_INT() */
	if (!(sns_ctx())) {
		ercd = chg_ipm(-1);
		check_ercd(ercd, E_OK);
		{
			SIL_PRE_LOC;
			SIL_LOC_INT();
			test_of_SIL_LOC_INT();
			SIL_UNL_INT();
		}
		ercd = chg_ipm(TIPM_ENAALL);
		check_ercd(ercd, E_OK);
		wait_raise_int();
		syslog_0(LOG_NOTICE, "test_of_SIL_LOC_INT() [j]: OK");
	}

	/* [k]dis_dsp() �� SIL_LOC_INT() */
	if (!(sns_ctx())) {
		ercd = dis_dsp();
		check_ercd(ercd, E_OK);
		{
			SIL_PRE_LOC;
			SIL_LOC_INT();
			test_of_SIL_LOC_INT();
			SIL_UNL_INT();
		}
		ercd = ena_dsp();
		check_ercd(ercd, E_OK);
		wait_raise_int();
		syslog_0(LOG_NOTICE, "test_of_SIL_LOC_INT() [k]: OK");
	}
}

void part_test(E_TEST_TYPE test_type) {

	/* [d]�����ͥ���٥ޥ���������Ǥʤ����� */
	/* [e]�ǥ����ѥå��ػ߾��� */
	test_of_SIL_LOC_INT();
	wait_raise_int();
	if (test_type == CHG_IPM) {
		syslog_0(LOG_NOTICE, "test_of_SIL_LOC_INT() [d]: OK");
	}
	else if (test_type == DIS_DSP) {
		syslog_0(LOG_NOTICE, "test_of_SIL_LOC_INT() [e]: OK");
	}

	/* [j]chg_ipm(-1) �� SIL_LOC_INT() */
	/* [k]dis_dsp() �� SIL_LOC_INT() */
	{
		SIL_PRE_LOC;
		SIL_LOC_INT();
		test_of_SIL_LOC_INT();
		SIL_UNL_INT();
	}
	wait_raise_int();
	if (test_type == CHG_IPM) {
		syslog_0(LOG_NOTICE, "test_of_SIL_LOC_INT() [j]: OK");
	}
	else if (test_type == DIS_DSP) {
		syslog_0(LOG_NOTICE, "test_of_SIL_LOC_INT() [k]: OK");
	}
}

void inthdr_for_int_test(void) {
	i_begin_int(TTSP_INTNO_A);
	ttsp_clear_int_req(TTSP_INTNO_A);

	/* ����ߤ����ä����Ȥ����� */
	int_flag = true;

	i_end_int(TTSP_INTNO_A);
}

void test_of_sil_dly_nse(void) {
	ER ercd;
	SYSTIM system1, system2;

	ercd = get_tim(&system1);
	check_ercd(ercd, E_OK);
	sil_dly_nse(SIL_DLY_TIME);
	ercd = get_tim(&system2);
	check_ercd(ercd, E_OK);
	check_assert((system2 - system1) >= SIL_DLY_TIME_SUB);

	syslog_0(LOG_NOTICE, "test_of_sil_dly_nse()    : OK");
}

void test_of_sil_mem(void) {
	check_of_sil_mem();

	{
		SIL_PRE_LOC;
		SIL_LOC_INT();
		check_of_sil_mem();
		SIL_UNL_INT();
	}

	syslog_0(LOG_NOTICE, "test_of_sil_mem()        : OK");
}

void test_of_sns_ker(bool_t flag) {
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

	syslog_0(LOG_NOTICE, "test_of_sns_ker()        : OK");
}

void test_of_SIL_LOC_INT(void) {
	SIL_PRE_LOC;

	/* �ե饰����� */
	int_flag = false;

	/* �ƥ����оݤ�SIL�ؿ�ȯ�� */
	SIL_LOC_INT();

	/* ����ߤ�ȯ�� */
	ttsp_int_raise(TTSP_INTNO_A);

	/* ����ߤ�ȯ�����ʤ����Ȥ��Ԥ� */
	sil_dly_nse(TTSP_WAIT_NOT_RAISE_INT);

	/* �ե饰����������Ƥ��ʤ����Ȥ��ǧ */
	check_assert(int_flag == false);

	/* ���ξ��֤��᤹ */
	/* (b-2/h-2/i-2/j-2/k-2�Υƥ��Ȥ��ͤ�) */
	SIL_UNL_INT();
}

void wait_raise_int(void) {
	ulong_t timeout = 0;

	/* ����ߤ�ȯ������Τ��Ԥ� */
	while (int_flag == false) {
		timeout++;
		if (timeout > TTSP_LOOP_COUNT) {
			syslog_0(LOG_ERROR, "## wait_raise_int() caused a timeout.");
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
