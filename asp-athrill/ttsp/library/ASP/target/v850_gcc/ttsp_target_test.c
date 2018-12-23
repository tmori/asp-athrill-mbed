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
 *  �嵭����Ԥϡ��ʲ���(1)���(4)�ξ������������˸¤ꡤ�ܥ��եȥ���
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
 *  $Id: ttsp_target_test.c 2 2012-05-09 02:23:52Z nces-shigihara $
 */

#include "kernel_impl.h"
#include <sil.h>
#include "ttsp_target_test.h"
#include "target_timer.h"

static unsigned int athrill_device_raise_interrupt __attribute__ ((section(".athrill_device_section")));
static unsigned int is_ttsp_target_timer_running = 1;

/*
 *  �ƥ��å����������
 */
void
ttsp_target_stop_tick(void)
{
	SIL_PRE_LOC;
	
	SIL_LOC_INT();

	dev_disable_int(INTNO_TIMER);
	SetTimerStopTAA(INTNO_TIMER);
	x_clear_int(INTNO_TIMER);
	SIL_UNL_INT();

	is_ttsp_target_timer_running = 0;
	return;
}

/*
 *  �ƥ��å������κƳ�
 */
void
ttsp_target_start_tick(void)
{
	SIL_PRE_LOC;
	
	SIL_LOC_INT();

	SetTimerStartTAA(TIMER_DTIM_ID);
	dev_enable_int(INTNO_TIMER);
	
	SIL_UNL_INT();

	is_ttsp_target_timer_running = 1;
	return;
}

/*
 *  �ƥ��å��ι���
 */
void
ttsp_target_gain_tick(void)
{
	SIL_PRE_LOC;

	SIL_LOC_INT();
	SetTimerStartTAA(TIMER_DTIM_ID);
	dev_enable_int(INTNO_TIMER);

	do_halt();

	SIL_UNL_INT();

	SIL_LOC_INT();
	dev_disable_int(INTNO_TIMER);
	SetTimerStopTAA(INTNO_TIMER);
	SIL_UNL_INT();

}

/*
 *  ����ߤ�ȯ��   
 */
void
ttsp_int_raise(INTNO intno)
{
	athrill_device_raise_interrupt = intno;
}

/*
 *  CPU�㳰��ȯ��
 */
void
ttsp_cpuexc_raise(EXCNO excno)
{
	do_trap(0x01);
}

/*
 *  CPU�㳰ȯ�����Υեå�����(athrill�Ǥ�����)
 */
void
ttsp_cpuexc_hook(EXCNO excno, void* p_excinf)
{
}

/*
 *  ������׵�Υ��ꥢ
 */
void
ttsp_clear_int_req(INTNO intno)
{
	x_clear_int(intno);
}

