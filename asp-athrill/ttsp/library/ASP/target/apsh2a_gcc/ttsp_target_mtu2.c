/*
 *  TTSP
 *      Toyohashi Open Platform for Embedded Real-Time Systems
 *      Test Suite Package
 * 
 *  Copyright (C) 2010-2011 by Center for Embedded Computing Systems
 *              Graduate School of Information Science, Nagoya Univ., JAPAN
 *  Copyright (C) 2010-2011 by Industrial Technology Institute,
 *								Miyagi Prefectural Government, JAPAN
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
 *  $Id: ttsp_target_mtu2.c 2 2012-05-09 02:23:52Z nces-shigihara $
 */

/*
 *  �ޥ���ե��󥯥���󥿥��ޥѥ륹��˥å�MTU2�ɥ饤��
 */

#include "kernel_impl.h"
#include <sil.h>
#include "ttsp_target_mtu2.h"


/*
 *  MTU2������֥�å������
 */
typedef struct mtu2_initialization_block {
	uint8_t  *p_tcr_b;		/* �����ޥ���ȥ���쥸����  */
	uint8_t  *p_tier_b;		/* �����ޥ��󥿥�ץȥ��͡��֥�쥸����  */
	uint8_t  *p_tsr_b;		/* �����ޥ��ơ�����������  */
	uint16_t *p_tcnt_h;		/* �����ޥ����� */
	uint8_t  start_bit;		/* �������ȥӥå� */
} MTU2INIB;

/*
 *  MTU2������֥�å�
 */
const MTU2INIB mtu2inib_table[] = {
	{
		(uint8_t *)TCR_0_b,
		(uint8_t *)TIER_0_b,
		(uint8_t *)TSR_0_b,
		(uint16_t *)TCNT_0_h,
		TSTR_CST0
	},
	{
		(uint8_t *)TCR_1_b,
		(uint8_t *)TIER_1_b,
		(uint8_t *)TSR_1_b,
		(uint16_t *)TCNT_1_h,
		TSTR_CST1
	},
	{
		(uint8_t *)TCR_2_b,
		(uint8_t *)TIER_2_b,
		(uint8_t *)TSR_2_b,
		(uint16_t *)TCNT_2_h,
		TSTR_CST2
	},
	{
		(uint8_t *)TCR_3_b,
		(uint8_t *)TIER_3_b,
		(uint8_t *)TSR_3_b,
		(uint16_t *)TCNT_3_h,
		TSTR_CST3
	},
	{
		(uint8_t *)TCR_4_b,
		(uint8_t *)TIER_4_b,
		(uint8_t *)TSR_4_b,
		(uint16_t *)TCNT_4_h,
		TSTR_CST4
	},
};


/*
 *  �����ޥ�������
 */
Inline void
ttsp_target_start_mtu2(const MTU2INIB *p_mtu2inib)
{
	/* MTU2����ͥ�n�������� */
	sil_orb_reg((uint8_t *)TSTR_b, p_mtu2inib->start_bit);
}

/*
 *  ���������
 */
Inline void
ttsp_target_stop_mtu2(const MTU2INIB *p_mtu2inib)
{
	/* MTU2����ͥ�n��� */
	sil_anb_reg((uint8_t *)TSTR_b, ~(p_mtu2inib->start_bit));
}

/*
 *  �����޳�����׵�򥯥ꥢ
 */
Inline void
ttsp_target_clear_mtu2_int(const MTU2INIB *p_mtu2inib)
{
	sil_anb_reg(p_mtu2inib->p_tsr_b, ~TCR_TCFV);
}

/*
 *  �����޳���ߤ����
 */
Inline void
ttsp_target_enable_mtu2_int(const MTU2INIB *p_mtu2inib)
{
	sil_orb_reg(p_mtu2inib->p_tier_b, TIER_TCIEV);
}

/*
 *  ����ڥ��ޥå��Ԥ�
 */
Inline void
ttsp_target_wait_compare_match_mtu2(const MTU2INIB *p_mtu2inib)
{
	uint8_t *p_tsr_b = p_mtu2inib->p_tsr_b;
	while((sil_reb_mem((void*)p_tsr_b) & TCR_TCFV) == 0U);
}

/*
 *  MTU2������ֹ椫�����ͥ��ֹ�ؤ��Ѵ�
 *  ��MTU2����ͥ�0-4���Ѥ��롣
 */
static int_t
ttsp_target_mtu2_intno2ch(INTNO intno)
{
	uint_t	ch = 0;
	
	switch(intno) {
		case MTU0_TGI0V_VECTOR:
			ch = 0;
			break;
		case MTU1_TGI1V_VECTOR:
			ch = 1;
			break;
		case MTU2_TGI2V_VECTOR:
			ch = 2;
			break;
		case MTU3_TGI3V_VECTOR:
			ch = 3;
			break;
		case MTU4_TGI4V_VECTOR:
			ch = 4;
			break;
		default:
			syslog_2(LOG_NOTICE, "Error: intno %d(0x%x) is not supported by MTU2 driver.",
		          (intptr_t)intno, (intptr_t)intno);
			ext_ker();
			break;
	}
	return ch;
}

/*
 *  MTU2����ߤ�ȯ��   
 *  ��MTU2����ͥ�0-4���Ѥ��롣
 */
void
ttsp_target_raise_mtu2_int(INTNO intno)
{
	int_t	ch;
	const MTU2INIB *p_mtu2inib;
	SIL_PRE_LOC;

	ch = ttsp_target_mtu2_intno2ch(intno);
	p_mtu2inib = &mtu2inib_table[ch];

	/*
	 *	MTU2����ͥ�n������
	 */

	/*  MTU2�˥���å��򶡵�  */
	SIL_LOC_INT();
	sil_anb_reg((uint8_t *)STBCR3_b, ~STBCR3_MTU2);
	sil_reb_mem((void *)STBCR3_b);		/*  ���ߡ��꡼��  */
	SIL_UNL_INT();
	sil_dly_nse(100);					/*  ����å������Ԥ�  */

	/*
	 *	�����޼��������ꤷ�������ޤ�ư��򳫻Ϥ��롥
	 */
	SIL_LOC_INT();

	/* MTU2����ͥ�n��� */
	ttsp_target_stop_mtu2(p_mtu2inib);

	/*
	 *	�������󥿥��ꥢ�װ�
	 *	������å�������
	 *	�����å�����
	 */
	sil_wrb_mem(p_mtu2inib->p_tcr_b, 0U);

	/* ���åץ����󥿤ν���ͤ򥻥å� */
	sil_wrh_mem(p_mtu2inib->p_tcnt_h, 0xfffc);

	/* ������׵�򥯥ꥢ */
	ttsp_target_clear_mtu2_int(p_mtu2inib);

	/* ����ߤε��� */
	ttsp_target_enable_mtu2_int(p_mtu2inib);

	/* MTU2����ͥ�n�������� */
	ttsp_target_start_mtu2(p_mtu2inib);

#if 0
	/* ����ڥ��ޥå��Ԥ� */
	ttsp_target_wait_compare_match_mtu2(p_mtu2inib);

	/* MTU2����ͥ�n��� */
	ttsp_target_stop_mtu2(p_mtu2inib);
#endif

	SIL_UNL_INT();

	/* �����ǳ���ߤ����� */
}

/*
 *  ������׵�Υ��ꥢ
 */
void
ttsp_clear_int_req_mtu2(INTNO intno)
{
	int_t	ch;
	const MTU2INIB *p_mtu2inib;
	SIL_PRE_LOC;

	ch = ttsp_target_mtu2_intno2ch(intno);
	p_mtu2inib = &mtu2inib_table[ch];

	SIL_LOC_INT();
	ttsp_target_stop_mtu2(p_mtu2inib);
	ttsp_target_clear_mtu2_int(p_mtu2inib);
	SIL_UNL_INT();
}

