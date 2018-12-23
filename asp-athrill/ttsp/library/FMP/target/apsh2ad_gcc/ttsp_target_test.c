/*
 *  TTSP
 *      TOPPERS Test Suite Package
 * 
 *  Copyright (C) 2010-2011 by Center for Embedded Computing Systems
 *              Graduate School of Information Science, Nagoya Univ., JAPAN
 *  Copyright (C) 2010-2011 by Digital Craft Inc.
 *  Copyright (C) 2010-2011 by NEC Communication Systems, Ltd.
 *  Copyright (C) 2010-2011 by FUJISOFT INCORPORATED
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
 *  $Id: ttsp_target_test.c 2 2012-05-09 02:23:52Z nces-shigihara $
 */

#include "kernel_impl.h"
#include "time_event.h"
#include <sil.h>
#include "ttsp_target_test.h"
#include "target_timer.h"
#include "ttsp_target_mtu2.h"

/*
 *  ������ֹ�γ������
 *  �������ƥॿ���ޡ�	CMT0
 *  ��TTSP_INTNO_A��	CMT1
 *  ��TTSP_INTNO_B��	CMT2
 *  ��TTSP_INTNO_C��	CMT3
 *  ��TTSP_INTNO_D��	MTU2 ch0
 *  ��TTSP_INTNO_PE2_A��MTU2 ch1
 *  ��TTSP_INTNO_PE2_B��MTU2 ch2
 *  ��TTSP_INTNO_PE2_C��MTU2 ch3
 *  ��TTSP_INTNO_PE2_D��MTU2 ch4
 */

/*
 *  CMT�Υ쥸�������
 */

/*
 *  �١������ɥ쥹����Υ��ե��åȤ������2�Х���ñ�̡�
 */
#define OFFSET_CMCSR_h	0U	/* �����ޥ���ȥ��롿���ơ������쥸���� */
#define OFFSET_CMCNT_h	1U	/* ����ڥ��ޥå������� */
#define OFFSET_CMCOR_h	2U	/* ����ڥ��ޥå����󥹥���ȥ쥸���� */

/*
 *  CMT������֥�å������
 */
typedef struct cmt_initialization_block {
	uint16_t *base_addr;	/* �١������ɥ쥹(CMCSR�쥸�����Υ��ɥ쥹)  */
	uint16_t *p_cmstr_h;	/* �����ޥ������ȥ쥸�����ʶ��ѡ� */
	uint32_t start_bit;		/* �������ȥӥå� */
} CMTINIB;

/*
 *  CMT������֥�å�
 */
const CMTINIB cmtinib_table[] = {
	{
		(uint16_t *)CMCSR_0_h,
		(uint16_t *)CMSTR_01_h,
		CMSTR_STR0
	},
	{
		(uint16_t *)CMCSR_1_h,
		(uint16_t *)CMSTR_01_h,
		CMSTR_STR1
	},
	{
		(uint16_t *)CMCSR_2_h,
		(uint16_t *)CMSTR_23_h,
		CMSTR_STR2
	},
	{
		(uint16_t *)CMCSR_3_h,
		(uint16_t *)CMSTR_23_h,
		CMSTR_STR3
	}
};


/*
 *  �����ޥ�������
 */
Inline void
ttsp_target_start_cmt(const CMTINIB *p_cmtinib)
{
	/* CMTn�������� */
	sil_orh_reg(p_cmtinib->p_cmstr_h, p_cmtinib->start_bit);
}

/*
 *  ���������
 */
Inline void
ttsp_target_stop_cmt(const CMTINIB *p_cmtinib)
{
	/* CMTn��� */
	sil_anh_reg(p_cmtinib->p_cmstr_h, ~(p_cmtinib->start_bit));
}

/*
 *  �����޳�����׵�򥯥ꥢ
 */
Inline void
ttsp_target_clear_cmt_int(const CMTINIB *p_cmtinib)
{
	sil_anh_reg(p_cmtinib->base_addr + OFFSET_CMCSR_h, ~CMCSR_CMF);
}

/*
 *  �����޳���ߤ����
 */
Inline void
ttsp_target_enable_cmt_int(const CMTINIB *p_cmtinib)
{
	sil_orh_reg(p_cmtinib->base_addr + OFFSET_CMCSR_h, CMCSR_CMIE);
}

/*
 *  ����ڥ��ޥå��Ԥ�
 */
Inline void
ttsp_target_wait_compare_match_cmt(const CMTINIB *p_cmtinib)
{
	uint16_t *p_cmcsr = p_cmtinib->base_addr + OFFSET_CMCSR_h;
	while((sil_reh_mem((void*)p_cmcsr) & CMCSR_CMF) == 0);
}

/*
 *  CMT������ֹ椫�����ͥ��ֹ�ؤ��Ѵ�
 */
Inline int_t
ttsp_target_cmt_intno2ch(INTNO intno)
{
	INTNO 	local_intno;
	int_t	ch;

	local_intno = intno & 0xffffU;
	ch = local_intno - CMI0_VECTOR;
	return ch;
}


/*
 *  CMT����ߤ�ȯ��   
 *  ��CMT1-3���Ѥ��롣
 */
static void
ttsp_target_raise_cmt_int(INTNO intno)
{
	int_t	ch;
	uint_t	bitptn;
	const CMTINIB *p_cmtinib;
	CLOCK	cyc = (TO_CLOCK(TIC_NUME, TIC_DENO)) - 1;
	SIL_PRE_LOC;

	ch = ttsp_target_cmt_intno2ch(intno);
	p_cmtinib = &cmtinib_table[ch];

	/*
	 *	CMTn������
	 */

	/*  CMTn�˥���å��򶡵�  */
	switch(ch) {
		case 0:
		case 1:
			bitptn = ~0x80U;
			break;
		case 2:
		case 3:
			bitptn = ~0x40U;
			break;
		default:
			bitptn = 0x00U;
			break;
	}
	SIL_LOC_SPN();
	sil_anb_reg((uint8_t *)STBCR7_b, bitptn);
	sil_reb_mem((void *)STBCR7_b);		/*  ���ߡ��꡼��  */
	SIL_UNL_SPN();
	sil_dly_nse(100);					/*  ����å������Ԥ�  */

	SIL_LOC_SPN();
	/*
	 *	�����޼��������ꤷ�������ޤ�ư��򳫻Ϥ��롥
	 */
	/* CMTn��� */
	ttsp_target_stop_cmt(p_cmtinib);

	/* �����޾���ͤΥ����å� */
	assert(cyc <= MAX_CLOCK);

	/* ʬ��������(PCLOCK/8)������ߵ��� */
	sil_wrh_mem(p_cmtinib->base_addr + OFFSET_CMCSR_h, (CMCSR_CKS | CMCSR_CMIE));

	/* ����ڥ��ޥå������󥹥���ȡ��쥸�����򥻥å� */
	sil_wrh_mem(p_cmtinib->base_addr + OFFSET_CMCOR_h, cyc);

	/* ������׵�򥯥ꥢ */
	ttsp_target_clear_cmt_int(p_cmtinib);

	/* ����ߤε��� */
	ttsp_target_enable_cmt_int(p_cmtinib);

	/* CMTn�������� */
	ttsp_target_start_cmt(p_cmtinib);

#if 0
	/* ����ڥ��ޥå��Ԥ� */
	ttsp_target_wait_compare_match_cmt(p_cmtinib);

	/* CMTn��� */
	ttsp_target_stop_cmt(p_cmtinib);
#endif

	SIL_UNL_SPN();

	/* �����ǳ���ߤ����� */
}

/*
 *  CMT������׵�Υ��ꥢ
 */
void
ttsp_clear_int_req_cmt(INTNO intno)
{
	int_t	ch;
	const CMTINIB *p_cmtinib;
	SIL_PRE_LOC;

	ch = ttsp_target_cmt_intno2ch(intno);
	p_cmtinib = &cmtinib_table[ch];

	SIL_LOC_SPN();
	/* CMTn��� */
	ttsp_target_stop_cmt(p_cmtinib);
	/* ������׵�򥯥ꥢ */
	ttsp_target_clear_cmt_int(p_cmtinib);
	SIL_UNL_SPN();
}

/*
 *  �ƥ��å��ѥ����ޥǥ��������֥��ѿ�
 */
static volatile bool_t target_timer_disable = false;

/*
 *  �ƥ��å��ѥ����ޥ�󥷥�åȼ¹�
 */
static volatile bool_t target_timer_oneshot = false;

/*
 *  �����ޥϥ�ɥ鳫�ϻ��˸ƤӽФ��եå�
 *  (false��signal_time()��ƤӽФ��ʤ�)
 */
static bool_t
ttsp_timer_handler_begin_hook(void)
{
	return (!target_timer_disable);
}

/*
 *  �����ޥϥ�ɥ齪λ���˸ƤӽФ��եå�
 */
static void
ttsp_timer_handler_end_hook(void)
{
	if (target_timer_oneshot) {
		target_timer_disable = true;
		target_timer_oneshot = false;
	}
}

/************�������˸�������ؿ���*************************/

/*
 *	�����ƥॿ���ޤˤϡ�CMT0�����
 */

/*
 *  �ƥ��å����������
 */
void
ttsp_target_stop_tick(void)
{
	SIL_PRE_LOC;
	SIL_LOC_SPN();

	/* ��������� */
	target_timer_disable = true;
	ttsp_target_stop_cmt(&cmtinib_table[0]);

	SIL_UNL_SPN();
}

/*
 *  �ƥ��å������κƳ�
 */
void
ttsp_target_start_tick(void)
{
	SIL_PRE_LOC;
	SIL_LOC_SPN();

	/* �����ޥ������� */
	target_timer_disable = false;
	ttsp_target_start_cmt(&cmtinib_table[0]);

	SIL_UNL_SPN();
}

/*
 *  �ƥ��å��ι���������ץ��å���
 *  �������Х륿���������ʤΤǡ�
 *  ��prcid�ˤϻ�������ץ��å��������ꤷ�ʤ���
 *  ��
 *  ��bool_t wait_flg
 *  ��        true�� �����޳���ߥϥ�ɥ�ν�λ�ޤ��Ԥ�
 *  ��        false�������޳���ߥϥ�ɥ�ν�λ�ޤ��Ԥ��ʤ�
 */
void
ttsp_target_gain_tick_pe(ID prcid, bool_t wait_flg)
{
	ID				pid;
	volatile PCB 	*p_pcb = get_mp_p_pcb(prcid);
	EVTTIM			current_time1, current_time2;
	ulong_t			timeout;
	SIL_PRE_LOC;

	assert(prcid == TOPPERS_SYSTIM_PRCID);

	/*
	 *  ����ι���������äƤ��뤳�Ȥ��ǧ
	 *  ��PE���Ф��Ƥϥ����å�����ɬ�פϤʤ����������å����Ƥ�����ʤ����ᡤ
	 *  �����å����롥 
	 */
	timeout = 0;
	while (target_timer_oneshot == true) {
		timeout++;
		if (timeout > TTSP_LOOP_COUNT) {
			syslog_2(LOG_ERROR, "## PE %d : ttsp_target_gain_tick_pe(%d)[check] caused a timeout.", pid, prcid);
			ext_ker();
		}
		sil_dly_nse(TTSP_SIL_DLY_NSE_TIME);
	};

	SIL_LOC_SPN();
	target_timer_oneshot = true;
	target_timer_disable = false;

	sil_get_pid(&pid);
	current_time1 = p_pcb->p_tevtcb->current_time;
	
	/* �����ޥ������� */
	ttsp_target_start_cmt(&cmtinib_table[0]);

	SIL_UNL_SPN();
	
	/* wait_flg��true�ξ��ϡ������ƥ���郎���������ޤ��Ԥ���碌�� */
	if (wait_flg) {
		timeout = 0;
		while(1){
			SIL_LOC_SPN();
			current_time2 = p_pcb->p_tevtcb->current_time;
			SIL_UNL_SPN();

			if (current_time1 != current_time2) {
				/* ��������� */
				SIL_LOC_SPN();
				ttsp_target_stop_cmt(&cmtinib_table[0]);
				SIL_UNL_SPN();
				break;
			} else {
				timeout++;
				if (timeout > TTSP_LOOP_COUNT) {
					syslog_2(LOG_ERROR, "## PE %d : ttsp_target_gain_tick_pe(%d)[wait] caused a timeout.",
					          pid, prcid);
					ext_ker();
				}
				sil_dly_nse(TTSP_SIL_DLY_NSE_TIME);
			}
		}
	}
}


/*
 *	�����޳���ߥϥ�ɥ�
 *	�������ͥ�Υ������ƥ������¸���ˤ���target_timer_handler�����شؿ�
 */
void
target_timer_handler(void)
{
								/* ������׵�򥯥ꥢ */
	ttsp_target_clear_cmt_int(&cmtinib_table[0]);
	
	i_begin_int(INTNO_TIMER_SYSTIM);
	if (ttsp_timer_handler_begin_hook()) {
		signal_time();                    /* ������ƥ��å��ζ��� */
		ttsp_timer_handler_end_hook();
	}
	i_end_int(INTNO_TIMER_SYSTIM);
}

/*
 *  ����ߤ�ȯ��   
 */
void
ttsp_int_raise(INTNO intno)
{
#ifdef TTSP_DEBUG_MESSAGE
	syslog_2(LOG_NOTICE, "ttsp_int_raise: intno %d(0x%x)",
		          (intptr_t)intno, (intptr_t)intno);
#endif	/*  TTSP_DEBUG_MESSAGE  */

	switch(intno) {

		case TTSP_INTNO_A:
		case TTSP_INTNO_B:
		case TTSP_INTNO_C:
			ttsp_target_raise_cmt_int(intno);
			break;
		
		case TTSP_INTNO_D:
		case TTSP_INTNO_PE2_A:
		case TTSP_INTNO_PE2_B:
		case TTSP_INTNO_PE2_C:
		case TTSP_INTNO_PE2_D:
			ttsp_target_raise_mtu2_int(intno);
			break;

		default:
			syslog_2(LOG_NOTICE, "Error: intno %d(0x%x) is not supported by ttsp_int_raise.",
		          (intptr_t)intno, (intptr_t)intno);
			ext_ker();
			break;
	}
}


/*
 *  ������׵�Υ��ꥢ
 */
void
ttsp_clear_int_req(INTNO intno)
{
#ifdef TTSP_DEBUG_MESSAGE
	syslog_2(LOG_NOTICE, "ttsp_clear_int_req: intno %d(0x%x)",
		          (intptr_t)intno, (intptr_t)intno);
#endif	/*  TTSP_DEBUG_MESSAGE  */

	switch(intno) {
		case TTSP_INTNO_A:
		case TTSP_INTNO_B:
		case TTSP_INTNO_C:
			ttsp_clear_int_req_cmt(intno);
			break;

		case TTSP_INTNO_D:
		case TTSP_INTNO_PE2_A:
		case TTSP_INTNO_PE2_B:
		case TTSP_INTNO_PE2_C:
		case TTSP_INTNO_PE2_D:
			ttsp_clear_int_req_mtu2(intno);
			break;

		default:
			syslog_2(LOG_NOTICE, "Error: intno %d(0x%x) is not supported by ttsp_clear_int_req.",
			          (intptr_t)intno, (intptr_t)intno);
			ext_ker();
			break;
	}
}


/*
 *	���ɥ쥹���顼�㳰ȯ���ؿ�
 *	��
 *	���㳰ȯ�����˥����å������򤵤��PC���ͤϡֺǸ�˼¹Ԥ���̿���
 *	���μ�̿�����Ƭ���ɥ쥹��ؤ��Ƥ��롣
 *	�����ΡֺǸ�˼¹Ԥ���̿��פȤϼºݤ˥��ɥ쥹���顼�㳰��ȯ��
 *	������̿��ǤϤʤ����㳰ȯ�����˥ѥ��ץ饤���Ǽ¹Ԥ���Ƥ���
 *	����³��̿��Ǥ��롣
 *	�����㳰��ȯ������̿�᤬���ꥢ���������ơ����ǡ���³��̿�᤬
 *	�������˼¹ԥ��ơ����ˤ������
 *	��
 *	���ޤ�����³��̿���ʬ��̿�᤬�ޤޤ����ϡ����򤹤٤�PC���ͤ�
 *	���񤭴������Ƥ��륱���������롣
 *	��
 *	���ֺǸ�˼¹Ԥ���̿��פ��㳰ȯ���ս꤫�鲿̿��Υ��Ƥ��뤫
 *	���쳵�ˤϵ����ʤ����ᡢ�����Ǥ�nop̿����������Ƥ��롣
 */
Inline void 
ttsp_target_raise_address_error(void)
{
	uint32_t tmp;
	uint32_t adr = 0xfffffec1U;		/*  �������  */
	
	Asm(" mov.l @%1, %0 \n"			/*  ���ɥ쥹���顼�㳰��ȯ��  */
	    " nop           \n"
	    " nop           \n"
	    " nop           \n"			/*  �������å������򤵤�륢�ɥ쥹  */
	    " nop           " : "=r"(tmp): "r"(adr));
}

/*
 *  CPU�㳰��ȯ��
 */
void
ttsp_cpuexc_raise(EXCNO excno)
{
	switch(excno) {
		case TTSP_EXCNO_A:
		case TTSP_EXCNO_PE2_A:
			ttsp_target_raise_address_error();
			break;

		default:
			syslog_2(LOG_NOTICE, "Error: excno %d(0%x) is not supported by ttsp_cpuexc_raise.",
		          (intptr_t)excno, (intptr_t)excno);
			break;
	}
}

/*
 *  CPU�㳰ȯ�����Υեå�����
 */
void
ttsp_cpuexc_hook(EXCNO excno, void* p_excinf)
{

}
