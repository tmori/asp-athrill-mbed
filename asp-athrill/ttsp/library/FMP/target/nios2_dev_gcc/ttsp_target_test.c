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
 *  $Id: ttsp_target_test.c 2 2012-05-09 02:23:52Z nces-shigihara $
 */

#include "kernel_impl.h"
#include "time_event.h"
#include "pcb.h"
#include <sil.h>
#include "ttsp_target_test.h"

/*
 *  ttsp_target_timer.c��󥯳�ǧ
 */
extern uint_t include_ttsp_target_timer_to_KERNEL_COBJS;
void
ttsp_target_timer_not_be_linked(void)
{
	include_ttsp_target_timer_to_KERNEL_COBJS = 1;
}

/*
 *  �ƥ��å��ѥ����ޥǥ��������֥��ѿ�
 */
static volatile bool_t target_timer_disable[TNUM_PRCID];

/*
 *  �ƥ��å��ѥ����ޥ�󥷥�åȼ¹�
 */
static volatile bool_t target_timer_oneshot[TNUM_PRCID];

/*
 *  �����ޥϥ�ɥ鳫�ϻ��˸ƤӽФ��եå�
 *  (false��signal_time()��ƤӽФ��ʤ�)
 */
bool_t
ttsp_timer_handler_begin_hook(void)
{
	return !target_timer_disable[x_prc_index()];
}

/*
 *  �����ޥϥ�ɥ齪λ���˸ƤӽФ��եå�
 */
void
ttsp_timer_handler_end_hook(void)
{
	uint_t prc_index = x_prc_index();
	if (target_timer_oneshot[prc_index]) {
		target_timer_disable[prc_index] = true;
		target_timer_oneshot[prc_index] = false;
	}
}

/*
 *  �����ޥϥ�ɥ�ƤӽФ���λ��ǧ�ؿ�
 */
void
ttsp_check_timer_handler(void)
{
	int_t		i;
	ID			pid;
	ulong_t		timeout;

	sil_get_pid(&pid);

	/* ����Υ����ޥϥ�ɥ餬��λ���Ƥ��뤫�����å� */
	for(i = 0; i < TNUM_PRCID; i++) {
		timeout = 0;
		while (target_timer_disable[i] == false) {
			timeout++;
			if (timeout > TTSP_LOOP_COUNT) {
				syslog_2(LOG_ERROR, "## PE %d : ttsp_check_timer_handler[PE:%d][check] caused a timeout.", pid, i + 1);
				ext_ker();
			}
			sil_dly_nse(TTSP_SIL_DLY_NSE_TIME);
		};
	}
}

/*
 *  �ƥ��å����������(���ץ��å�)
 */
void
ttsp_target_stop_tick(void)
{
	uint_t i;

	for(i = 1; i <= TNUM_PRCID; i++) {
		ttsp_target_stop_tick_pe(i);
	}
}

/*
 *  �ƥ��å����������(����ץ��å�)
 */
void
ttsp_target_stop_tick_pe(ID prcid)
{
	uint_t prc_index = prcid - 1;
	target_timer_disable[prc_index] = true;
}

/*
 *  �ƥ��å������κƳ������ץ��å���
 */
void
ttsp_target_start_tick(void)
{
	uint_t i;

	for(i = 1; i <= TNUM_PRCID; i++) {
		ttsp_target_start_tick_pe(i);
	}
}

/*
 *  �ƥ��å������κƳ�������ץ��å���
 */
void
ttsp_target_start_tick_pe(ID prcid)
{
	uint_t prc_index = prcid - 1;
	target_timer_disable[prc_index] = false;
}

/*
 *  �ƥ��å��ι���������ץ��å���
 */
void
ttsp_target_gain_tick_pe(ID prcid, bool_t wait_flg)
{
	int			prc_index = prcid - 1;
	ID			pid;
	ulong_t		timeout;

	sil_get_pid(&pid);

	/*
	 *  ����ι���������äƤ��뤳�Ȥ��ǧ
	 *  ��PE���Ф��Ƥϥ����å�����ɬ�פϤʤ����������å����Ƥ�����ʤ����ᡤ
	 *  �����å����롥 
	 */
	timeout = 0;
	while (target_timer_oneshot[prc_index] == true) {
		timeout++;
		if (timeout > TTSP_LOOP_COUNT) {
			syslog_2(LOG_ERROR, "## PE %d : ttsp_target_gain_tick_pe(%d)[check] caused a timeout.", pid, prcid);
			ext_ker();
		}
		sil_dly_nse(TTSP_SIL_DLY_NSE_TIME);
	};

	target_timer_oneshot[prc_index] = true;
	target_timer_disable[prc_index] = false;

	/* wait_flg��true�ξ��ϡ��ϥ�ɥ餬��λ����ޤ��Ԥ���碌�� */
	if (wait_flg == true) {
		timeout = 0;
		while (target_timer_oneshot[prc_index] == true) {
			timeout++;
			if (timeout > TTSP_LOOP_COUNT) {
				syslog_2(LOG_ERROR, "## PE %d : ttsp_target_gain_tick_pe(%d)[wait] caused a timeout.", pid, prcid);
				ext_ker();
			}
			sil_dly_nse(TTSP_SIL_DLY_NSE_TIME);
		};
	}
}

/*
 *  �ƥ��å��ι��������ץ��å���
 */
void
ttsp_target_gain_tick(void)
{
	int_t		i;
	ID			pid;
	ulong_t		timeout;
	int			prc_index;

	/* ��PE������Υƥ��å�������������λ�������Ȥ��ǧ */
	ttsp_check_timer_handler();

	/* �ᥤ��ץ��å�ID���� */
	sil_get_pid(&pid);
	prc_index = pid - 1;

	/*
	 *  ����ι���������äƤ��뤳�Ȥ��ǧ
	 *  ��PE���Ф��Ƥϥ����å�����ɬ�פϤʤ����������å����Ƥ�����ʤ����ᡤ
	 *  �����å����롥 
	 */
	for(i = 0; i < TNUM_PRCID; i++) {
		if (i != prc_index) {
			timeout = 0;
			while (target_timer_oneshot[i] == true) {
				timeout++;
				if (timeout > TTSP_LOOP_COUNT) {
					syslog_2(LOG_ERROR, "## PE %d : ttsp_target_gain_tick[PE:%d][check] caused a timeout.", pid, i + 1);
					ext_ker();
				}
				sil_dly_nse(TTSP_SIL_DLY_NSE_TIME);
			};
		}
	}

	for(i = 0; i < TNUM_PRCID; i++) {
		if (i != prc_index) {
			target_timer_oneshot[i] = true;
		}
	}

	for(i = 0; i < TNUM_PRCID; i++) {
		if (i != prc_index) {
			target_timer_disable[i] = false;
		}
	}

	/* ��PE���Ф��ơ��ϥ�ɥ餬��λ����ޤ��Ԥ���碌�� */
	for(i = 0; i < TNUM_PRCID; i++) {
		if (i != prc_index) {
			timeout = 0;
			while (target_timer_oneshot[i] == true) {
				timeout++;
				if (timeout > TTSP_LOOP_COUNT) {
					syslog_2(LOG_ERROR, "## PE %d : ttsp_target_gain_tick[PE:%d][wait] caused a timeout.", pid, i + 1);
					ext_ker();
				}
				sil_dly_nse(TTSP_SIL_DLY_NSE_TIME);
			};
		}
	}

	/* �Ǹ�˥ᥤ��ץ��å��λ����ʤ�� */
	timeout = 0;
	while (target_timer_oneshot[prc_index] == true) {
		timeout++;
		if (timeout > TTSP_LOOP_COUNT) {
			syslog_2(LOG_ERROR, "## PE %d : ttsp_target_gain_tick[PE:%d][check] caused a timeout.", pid, pid);
			ext_ker();
		}
		sil_dly_nse(TTSP_SIL_DLY_NSE_TIME);
	};
	target_timer_oneshot[prc_index] = true;
	target_timer_disable[prc_index] = false;
	timeout = 0;
	while (target_timer_oneshot[prc_index] == true) {
		timeout++;
		if (timeout > TTSP_LOOP_COUNT) {
			syslog_2(LOG_ERROR, "## PE %d : ttsp_target_gain_tick[PE:%d][wait] caused a timeout.", pid, pid);
			ext_ker();
		}
		sil_dly_nse(TTSP_SIL_DLY_NSE_TIME);
	};
}


/*
 * �����HW�Υ��ɥ쥹�ơ��֥�
 */
const uint32_t target_ttsp_int_base_table[TNUM_PRCID][3] = {
	{0x07114000,0x07114010,0x07114020},
	{0x07114030,0x07114040,0x07114050},
};

/*
 *  ����ߤ�ȯ��
 */
void
ttsp_int_raise(INTNO intno)
{
	uint_t index;
	uint_t prcid;

	index = INTNO_MASK(intno);
	index -= 7; /* ������ֹ��7����Ϣ�֤Ǥ��뤳�Ȥ����� */
	prcid = intno >> 16;
	sil_wrw_mem((void *)(target_ttsp_int_base_table[prcid-1][index]), 0x01);
}

/*
 *  CPU�㳰��ȯ��
 */
void
ttsp_cpuexc_raise(EXCNO excno)
{
	if (excno == TTSP_EXCNO_A) {
		RAISE_CPU_EXCEPTION;
	}
#ifdef TTSP_EXCNO_PE2_A
	if (excno == TTSP_EXCNO_PE2_A) {
		RAISE_CPU_EXCEPTION;
	}
#endif /* TTSP_EXCNO_PE2_A */
#ifdef TTSP_EXCNO_PE3_A
	if (excno == TTSP_EXCNO_PE3_A) {
		RAISE_CPU_EXCEPTION;
	}
#endif /* TTSP_EXCNO_PE3_A */
#ifdef TTSP_EXCNO_PE4_A
	if (excno == TTSP_EXCNO_PE4_A) {
		RAISE_CPU_EXCEPTION;
	}
#endif /* TTSP_EXCNO_PE4_A */
}

/*
 *  CPU�㳰ȯ�����Υեå�����
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
	uint_t index;
	uint_t prcid;

	index = INTNO_MASK(intno);
	index -= 7; /* ������ֹ��7����Ϣ�֤Ǥ��뤳�Ȥ����� */
	prcid = intno >> 16;
	sil_wrw_mem((void *)(target_ttsp_int_base_table[prcid-1][index]), 0x00);
}

