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
 *  $Id: ttsp_chip_timer.c 12 2012-10-31 04:51:45Z ertl-sangorrin $
 */

/*
 *  �����ޥɥ饤�С�ARM PrimeCell Timer Module�ѡ�
 */

#include "kernel_impl.h"
#include "time_event.h"
#include <sil.h>
#include "chip_timer.h"
#include "ttsp_chip_timer.h"
#include "ttsp_target_test.h"

/*
 *  ttsp_chip_timer.c��󥯳�ǧ�ѥ����Х��ѿ�
 */
uint_t include_ttsp_chip_timer_to_KERNEL_COBJS = 0;

/*
 *  �ƥ����Ѥδؿ�
 */

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
static bool_t
ttsp_timer_handler_begin_hook(void)
{
        return !target_timer_disable[x_prc_index()];
}

/*
 *  �����ޥϥ�ɥ齪λ���˸ƤӽФ��եå�
 */
static void
ttsp_timer_handler_end_hook(void)
{
        uint_t prc_index = x_prc_index();
        if (target_timer_oneshot[prc_index]) {
                target_timer_disable[prc_index] = true;
                target_timer_oneshot[prc_index] = false;
        }
}

/*
 *  �����޳�����׵�Υ��ꥢ
 */
Inline void
target_timer_int_clear(void)
{
	/* �ڥ�ǥ��󥰥ӥåȤ򥯥ꥢ */
	sil_wrw_mem((void *)MPCORE_TM_ISR, MPCORE_TM_ISR_SCBIT);
}

/*
 *  �����ޤε�ư����
 */
void
target_timer_initialize(intptr_t exinf)
{
	CLOCK    cyc = TO_CLOCK(TIC_NUME, TIC_DENO);

	/* ��������� */
	sil_wrw_mem((void *)MPCORE_TM_CNT, 0x00);

	/* �ڥ�ǥ��󥰥ӥåȥ��ꥢ */
	target_timer_int_clear();

	/* �����ͤ����� */
	sil_wrw_mem((void *)MPCORE_TM_LR, cyc - 1);

	/*
	 * �����ޡ���������(����ߵ���)
	 * 1MHz�ǥ�����Ȥ���褦�˥ץꥹ�����顼������
	 */
	sil_wrw_mem((void *)MPCORE_TM_CNT,
				(MPCORE_TM_PS_1MS << MPCORE_TM_CNT_PS_OFFSET)
				| MPCORE_TM_CNT_IEN | MPCORE_TM_CNT_AR | MPCORE_TM_CNT_EN);
}

/*
 *  �����ޤ���߽���
 */
void
target_timer_terminate(intptr_t exinf)
{
	/* ����ߥ��ꥢ */
	target_timer_int_clear();

	/* ��������� */
	sil_wrw_mem((void *)MPCORE_TM_CNT, 0x00);
}

/*
 *  �����޳���ߥϥ�ɥ�
 */
void
target_timer_handler(void)
{
	ID prcid;

	/* ����ߥ��ꥢ */
	target_timer_int_clear();

	iget_pid(&prcid);
	i_begin_int((0x10000 << (prcid - 1))|DIC_IRQNO_TM);
	if (ttsp_timer_handler_begin_hook()) {
		signal_time();                    /* ������ƥ��å��ζ��� */
		ttsp_timer_handler_end_hook();
	}
	i_end_int((0x10000 << (prcid - 1))|DIC_IRQNO_TM);
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

	/* ��PE�⤷���ϥե饰��true�ξ��ϡ��ϥ�ɥ餬��λ����ޤ��Ԥ���碌�� */
	if ((pid == prcid) || (wait_flg == true)) {
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

