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

/* sil_dly_nse�ˤ���ٱ��������(10�ߥ���) */
#define SIL_DELAY_TIME 10000000

void main_task(intptr_t exinf){
	int i;
	SYSTIM system1, system2;

	ttsp_initialize_test_lib();

	/* ���֤��ʤ�Ǥ��뤳�Ȥ��ǧ */
	get_tim(&system1);
	sil_dly_nse(SIL_DELAY_TIME);
	get_tim(&system2);
	check_assert(system1 < system2);
	syslog_1(LOG_NOTICE, "\nsystem1 : %d", system1);
	syslog_1(LOG_NOTICE, "system2 : %d", system2);
	syslog_0(LOG_NOTICE, "timer_interrupt : OK");

	/* ���֤��ߤޤ뤳�Ȥ��ǧ */
	ttsp_target_stop_tick();
	get_tim(&system1);
	sil_dly_nse(SIL_DELAY_TIME);
	get_tim(&system2);
	check_assert(system1 == system2);
	syslog_1(LOG_NOTICE, "system1 : %d", system1);
	syslog_1(LOG_NOTICE, "system2 : %d", system2);
	syslog_0(LOG_NOTICE, "ttsp_target_stop_tick() : OK");

	/* ���֤�1�ƥ��å����Ŀʤ���뤳�Ȥ��ǧ */
	for(i = 0; i < 10; i++){
		get_tim(&system1);
		ttsp_target_gain_tick();
		sil_dly_nse(SIL_DELAY_TIME);
		get_tim(&system2);
		check_assert((system1 + 1) == system2);
	}
	syslog_1(LOG_NOTICE, "system1 : %d", system1);
	syslog_1(LOG_NOTICE, "system2 : %d", system2);
	syslog_0(LOG_NOTICE, "ttsp_target_gain_tick() : OK");

	/* ���֤�ư���Ф����Ȥ��ǧ */
	ttsp_target_start_tick();
	get_tim(&system1);
	sil_dly_nse(SIL_DELAY_TIME);
	get_tim(&system2);
	check_assert(system1 < system2);
	syslog_1(LOG_NOTICE, "system1 : %d", system1);
	syslog_1(LOG_NOTICE, "system2 : %d", system2);
	syslog_0(LOG_NOTICE, "ttsp_target_start_tick() : OK");

	ttsp_check_finish(1);
}
