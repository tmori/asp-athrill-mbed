/*
 *  TTSP
 *      TOPPERS Test Suite Package
 * 
 *  Copyright (C) 2009-2012 by Center for Embedded Computing Systems
 *              Graduate School of Information Science, Nagoya Univ., JAPAN
 *  Copyright (C) 2009-2011 by Digital Craft Inc.
 *  Copyright (C) 2009-2011 by NEC Communication Systems, Ltd.
 *  Copyright (C) 2009-2012 by FUJISOFT INCORPORATED
 *  Copyright (C) 2009-2010 by Mitsuhiro Matsuura
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
 *  $Id: out.c 24 2015-12-09 06:00:31Z ertl-toshinaga $
 */
#include <kernel.h>
#include <t_syslog.h>
#include "syssvc/syslog.h"
#include "kernel_cfg.h"
#include "ttsp_test_lib.h"
#include "out.h"

#ifndef TTSP_FMP
extern const SIZE   _kernel_istksz;
extern STK_T *const _kernel_istk;
#else
extern const SIZE   _kernel_istksz_table[TNUM_PRCID];
extern STK_T *const _kernel_istk_table[TNUM_PRCID];
#endif

STK_T nontask_stack[TTSP_NON_TASK_STACK_SIZE];

void task1(intptr_t exinf){
	ER ercd;

	ttsp_initialize_test_lib();
	syslog_0(LOG_NOTICE,"ASP_staticAPI_DEF_ICS_d_2: Start");

	ttsp_check_point(1);
	ercd = sta_alm(ALM1,0);
	check_ercd(ercd,E_OK);

	ercd = dly_tsk(1);
	check_ercd(ercd,E_OK);

	syslog_0(LOG_NOTICE,"ASP_staticAPI_DEF_ICS_d_2: OK");

	ttsp_check_finish(3);
}
void alm1(intptr_t exinf){
	ER ercd;

	ttsp_check_point(2);

	#ifndef TTSP_FMP 
	check_assert(TTSP_NON_TASK_STACK_SIZE == _kernel_istksz);
	check_assert(&ercd > (ER*)((char *)_kernel_istk));							/* �������ѿ��������å����ΰ���ˤ��뤫��ǧ */
	check_assert(&ercd < (ER*)((char *)_kernel_istk + TTSP_NON_TASK_STACK_SIZE));	/* �������ѿ��������å����ΰ���ˤ��뤫��ǧ */
	#else
	check_assert(TTSP_NON_TASK_STACK_SIZE == _kernel_istksz_table[0]);
	check_assert(&ercd > (ER*)((char *)_kernel_istk_table[0]));								/* �������ѿ��������å����ΰ���ˤ��뤫��ǧ */
	check_assert(&ercd < (ER*)((char *)_kernel_istk_table[0] + TTSP_NON_TASK_STACK_SIZE));	/* �������ѿ��������å����ΰ���ˤ��뤫��ǧ */
	#endif
}
