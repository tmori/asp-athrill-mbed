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

#define LOOP_TIME 10

/* sil_dly_nse�ˤ���ٱ��������(10�ߥ���) */
#define SIL_DELAY_TIME 10000000

void main_task(intptr_t exinf){
	int i;
	ulong_t timeout = 0;
	SYSTIM system1, system2;
	ID prcid, tskid;
	get_pid(&prcid);
	get_tid(&tskid);

	/* ���֤��ʤ�Ǥ��뤳�Ȥ��ǧ */
	get_tim(&system1);
	sil_dly_nse(SIL_DELAY_TIME);
	get_tim(&system2);
	check_assert(system1 < system2);
	syslog_2(LOG_NOTICE, "[PE%d]system1 : %d", prcid, system1);
	syslog_2(LOG_NOTICE, "[PE%d]system2 : %d", prcid, system2);
	syslog_1(LOG_NOTICE, "[PE%d]timer_interrupt : OK", prcid);

	/* ���֤��ߤޤ뤳�Ȥ��ǧ */
	if (TOPPERS_MASTER_PRCID == prcid){
		ttsp_target_stop_tick();
	}
	ttsp_barrier_sync(1, TNUM_PRCID);
	get_tim(&system1);
	sil_dly_nse(SIL_DELAY_TIME);
	get_tim(&system2);
	check_assert(system1 == system2);
	syslog_2(LOG_NOTICE, "[PE%d]system1 : %d", prcid, system1);
	syslog_2(LOG_NOTICE, "[PE%d]system2 : %d", prcid, system2);
	syslog_1(LOG_NOTICE, "[PE%d]ttsp_target_stop_tick() : OK", prcid);

	/* ����Υץ��å��λ��֤�1�ƥ��å����Ŀʤ���뤳�Ȥ��ǧ
	   (���֤��ʤ�ޤǥ꥿���󤷤ʤ�)*/
	for(i = 0; i < LOOP_TIME; i++){
		get_tim(&system1);
		ttsp_barrier_sync(i + 2, TNUM_PRCID);
		if (TOPPERS_MASTER_PRCID == prcid) {
#ifdef TOPPERS_SYSTIM_GLOBAL
			ttsp_target_gain_tick_pe(TOPPERS_SYSTIM_PRCID, true);
#else /* TOPPERS_SYSTIM_LOCAL */
			ttsp_target_gain_tick_pe(1, true);
#if TNUM_PRCID >= 2
			ttsp_target_gain_tick_pe(2, true);
#endif /* TNUM_PRCID >= 2 */
#if TNUM_PRCID >= 3
			ttsp_target_gain_tick_pe(3, true);
#endif /* TNUM_PRCID >= 3 */
#if TNUM_PRCID >= 4
			ttsp_target_gain_tick_pe(4, true);
#endif /* TNUM_PRCID >= 4 */
#endif /* TOPPERS_SYSTIM_LOCAL */
		}
		ttsp_barrier_sync(++i + 2, TNUM_PRCID);
		get_tim(&system2);
		check_assert((system1 + 1) == system2);
	}
	syslog_2(LOG_NOTICE, "[PE%d]system1 : %d", prcid, system1);
	syslog_2(LOG_NOTICE, "[PE%d]system2 : %d", prcid, system2);
#ifdef TOPPERS_SYSTIM_GLOBAL
	syslog_2(LOG_NOTICE, "[PE%d]ttsp_target_gain_tick_pe(%d, true) : OK", prcid, TOPPERS_SYSTIM_PRCID);
#else /* TOPPERS_SYSTIM_LOCAL */
	syslog_2(LOG_NOTICE, "[PE%d]ttsp_target_gain_tick_pe(%d, true) : OK", prcid, prcid);
#endif /* TOPPERS_SYSTIM_LOCAL */

	/* ����Υץ��å��λ��֤�1�ƥ��å����Ŀʤ���뤳�Ȥ��ǧ
	   (�����˥꥿���󤹤�)*/
	for(i = 0; i < LOOP_TIME; i++){
		get_tim(&system1);
		ttsp_barrier_sync(i + LOOP_TIME + 4, TNUM_PRCID);
		if (TOPPERS_MASTER_PRCID == prcid) {
#ifdef TOPPERS_SYSTIM_GLOBAL
			ttsp_target_gain_tick_pe(TOPPERS_SYSTIM_PRCID, false);
#else /* TOPPERS_SYSTIM_LOCAL */
			ttsp_target_gain_tick_pe(1, false);
#if TNUM_PRCID >= 2
			ttsp_target_gain_tick_pe(2, false);
#endif /* TNUM_PRCID >= 2 */
#if TNUM_PRCID >= 3
			ttsp_target_gain_tick_pe(3, false);
#endif /* TNUM_PRCID >= 3 */
#if TNUM_PRCID >= 4
			ttsp_target_gain_tick_pe(4, false);
#endif /* TNUM_PRCID >= 4 */
#endif /* TOPPERS_SYSTIM_LOCAL */
		}
		do {
			get_tim(&system2);
			timeout++;
			if (timeout > TTSP_LOOP_COUNT) {
				syslog_1(LOG_ERROR, "## PE %d : main_task caused a timeout", prcid);
				syslog_1(LOG_ERROR, "## by \"ttsp_target_gain_tick_pe(%d, false)\".", prcid);
				ttsp_set_cp_state(false);
				ext_ker();
			}
			sil_dly_nse(TTSP_SIL_DLY_NSE_TIME);
		} while (system1 == system2);
		ttsp_barrier_sync(++i + LOOP_TIME + 4, TNUM_PRCID);
	}
	syslog_2(LOG_NOTICE, "[PE%d]system1 : %d", prcid, system1);
	syslog_2(LOG_NOTICE, "[PE%d]system2 : %d", prcid, system2);
#ifdef TOPPERS_SYSTIM_GLOBAL
	syslog_2(LOG_NOTICE, "[PE%d]ttsp_target_gain_tick_pe(%d, false) : OK", prcid, TOPPERS_SYSTIM_PRCID);
#else /* TOPPERS_SYSTIM_LOCAL */
	syslog_2(LOG_NOTICE, "[PE%d]ttsp_target_gain_tick_pe(%d, false) : OK", prcid, prcid);
#endif /* TOPPERS_SYSTIM_LOCAL */

	/* ���ΤΥץ��å��λ��֤�1�ƥ��å����Ŀʤ���뤳�Ȥ��ǧ */
#ifdef TOPPERS_SYSTIM_LOCAL
	for(i = 0; i < LOOP_TIME; i++){
		get_tim(&system1);
		ttsp_barrier_sync(i + (LOOP_TIME * 2) + 4, TNUM_PRCID);
		if (TOPPERS_MASTER_PRCID == prcid) {
			ttsp_target_gain_tick();
		}
		ttsp_barrier_sync(++i + (LOOP_TIME * 2) + 4, TNUM_PRCID);
		get_tim(&system2);
		check_assert((system1 + 1) == system2);
	}
	syslog_2(LOG_NOTICE, "[PE%d]system1 : %d", prcid, system1);
	syslog_2(LOG_NOTICE, "[PE%d]system2 : %d", prcid, system2);
	syslog_2(LOG_NOTICE, "[PE%d]ttsp_target_gain_tick() : OK", prcid, prcid);
#endif /* TOPPERS_SYSTIM_LOCAL */

	/* ���֤�ư���Ф����Ȥ��ǧ */
	if (TOPPERS_MASTER_PRCID == prcid) {
		ttsp_target_start_tick();
	}
	ttsp_barrier_sync((LOOP_TIME * 3) + 4, TNUM_PRCID);
	get_tim(&system1);
	sil_dly_nse(SIL_DELAY_TIME);
	get_tim(&system2);
	check_assert(system1 < system2);
	syslog_2(LOG_NOTICE, "[PE%d]system1 : %d", prcid, system1);
	syslog_2(LOG_NOTICE, "[PE%d]system2 : %d", prcid, system2);
	syslog_1(LOG_NOTICE, "[PE%d]ttsp_target_start_tick() : OK", prcid);

	ttsp_barrier_sync((LOOP_TIME * 3) + 5, TNUM_PRCID);

	if (TOPPERS_MASTER_PRCID == prcid) {
		ttsp_mp_check_finish(prcid, 1);
	}
}

void ttsp_test_lib_init(intptr_t exinf){
	ttsp_initialize_test_lib();
}
