/*
 *  TTSP
 *      TOPPERS Test Suite Package
 * 
 *  Copyright (C) 2011 by Center for Embedded Computing Systems
 *              Graduate School of Information Science, Nagoya Univ., JAPAN
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
 *  $Id: ttsp_target_test.c 2 2012-05-09 02:23:52Z nces-shigihara $
 */

#include "kernel_impl.h"
#include <sil.h>
#include "ttsp_target_test.h"

/*
 *  �ƥ��å����������
 */
void
ttsp_target_stop_tick(void)
{
	uint32_t tmp;
	tmp = sil_rew_mem((void *)SYSTIC_CONTROL_STATUS);
	tmp &= ~SYSTIC_ENABLE;
	sil_wrw_mem((void *)SYSTIC_CONTROL_STATUS, tmp);
}

/*
 *  �ƥ��å������κƳ�
 */
void
ttsp_target_start_tick(void)
{
	uint32_t tmp;
	tmp = sil_rew_mem((void *)SYSTIC_CONTROL_STATUS);
	tmp |= SYSTIC_ENABLE;
	sil_wrw_mem((void *)SYSTIC_CONTROL_STATUS, tmp);
}

/*
 *  �ƥ��å��ι���
 */
void
ttsp_target_gain_tick(void)
{
	uint32_t tmp;
	SIL_PRE_LOC;
	
	SIL_LOC_INT();
	/* �����޺Ƴ� */
	tmp = sil_rew_mem((void *)SYSTIC_CONTROL_STATUS);
	tmp |= SYSTIC_ENABLE;
	sil_wrw_mem((void *)SYSTIC_CONTROL_STATUS, tmp);
	
	/* ����ߤ�ȯ������ޤ��Ԥ� */
	do{
		tmp = sil_rew_mem((void *)SYSTIC_CONTROL_STATUS);
	}while((tmp & SYSTIC_COUNTFLAG) != SYSTIC_COUNTFLAG);

	/* ��������� */
	tmp = sil_rew_mem((void *)SYSTIC_CONTROL_STATUS);
	tmp &= ~SYSTIC_ENABLE;
	sil_wrw_mem((void *)SYSTIC_CONTROL_STATUS, tmp);
	SIL_UNL_INT();
}

/*
 *  ����ߤ�ȯ��   
 */
void
ttsp_int_raise(INTNO intno){
	int tmp = intno - 16;
	sil_wrw_mem((void *)((uint32_t *)0xE000E200 + (tmp >> 5)),
				(1 << (tmp & 0x1f)));
}

/*
 *  CPU�㳰��ȯ��������̿��
 */
__asm static void _raise_exception(void) {
	mcr p15, 0, r1, c2, c0, 0  
	bx   lr
}

/*
 *  CPU�㳰��ȯ��
 */
void
ttsp_cpuexc_raise(EXCNO excno)
{
	if (excno == TTSP_EXCNO_A) {
		_raise_exception();
	}
}

/*
 *  ������׵�Υ��ꥢ(�ƥ����ѡ�����)
 */
void
ttsp_clear_int_req(INTNO intno)
{

}

/*
 *  CPU�㳰�ϥ�ɥ�����������
 */
void
ttsp_cpuexc_hook(EXCNO excno, void* p_excinf) {
	/* ��ꥢ�ɥ쥹������ */
	*((uint32_t *)p_excinf + 8) = *((uint32_t *)p_excinf + 8) + 4;
}
