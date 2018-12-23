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

void main_task(intptr_t exinf){
	ER ercd;

	ttsp_initialize_test_lib();

	ttsp_check_point(1);

	/* �¹���Υ������������ߤ�ȯ�� */

	/* ����ߤ򵯤��� */
	ttsp_int_raise(TTSP_INTNO_A);
	ttsp_wait_check_point(2);

	ttsp_check_point(3);

	/* �¹���Υ������㳰�����롼���󤫤����ߤ�ȯ�� */

	/* �������㳰���ľ��֤ˤ��� */
	ercd = ena_tex();
	check_ercd(ercd, E_OK);

	/* �������㳰�򵯤��� */
	ercd = ras_tex(TSK_SELF, 0x00000001);
	check_ercd(ercd, E_OK);

	ttsp_check_point(7);

	/* ����ߥ����ӥ��롼���� */
#ifdef TTSP_INTNO_D
	ttsp_int_raise(TTSP_INTNO_D);
	ttsp_wait_check_point(8);
#ifdef TTSP_INTNO_E
	ttsp_int_raise(TTSP_INTNO_E);
	ttsp_wait_check_point(9);
#ifdef TTSP_INTNO_F
	ttsp_int_raise(TTSP_INTNO_F);
	ttsp_wait_check_point(10);
#else
	ttsp_check_point(10);
#endif /* TTSP_INTNO_F */
#else
	ttsp_check_point(9);
	ttsp_check_point(10);
#endif /* TTSP_INTNO_E */
#else
	ttsp_check_point(8);
	ttsp_check_point(9);
	ttsp_check_point(10);
#endif /* TTSP_INTNO_D */

#ifdef TTSP_INTNO_B
	/* ͥ���٤��ۤʤ����ߤ��㢪�梪��ν�ǵ����� */
	ttsp_int_raise(TTSP_INTNO_A);
	ttsp_wait_check_point(11);

	ttsp_check_finish(16);
#else
	ttsp_check_finish(11);
#endif /* TTSP_INTNO_B */
}

void texhdr_tex(TEXPTN texptn, intptr_t exinf){
	ttsp_check_point(4);

	/* ����ߤ򵯤��� */
	ttsp_int_raise(TTSP_INTNO_A);
	ttsp_wait_check_point(5);

	ttsp_check_point(6);
}

void inthdr_ttsp_intno_a(void){
	static uint_t bootcnt = 0;

	i_begin_int(TTSP_INTNO_A);
	ttsp_clear_int_req(TTSP_INTNO_A);

	bootcnt++;

	if (bootcnt == 1){
		ttsp_check_point(2);
		syslog_0(LOG_NOTICE, "ttsp_int_raise(TTSP_INTNO_A) : OK");
	}
	if(bootcnt == 2){
		ttsp_check_point(5);
		syslog_0(LOG_NOTICE, "ttsp_int_raise(TTSP_INTNO_A) : OK");
	}
#ifdef TTSP_INTNO_B
	if(bootcnt == 3){
		ttsp_check_point(11);
		syslog_0(LOG_NOTICE, "ttsp_int_raise(TTSP_INTNO_A) : OK");

		/* ����ߤ򵯤��� */
		ttsp_int_raise(TTSP_INTNO_B);
		ttsp_wait_check_point(12);

		ttsp_check_point(15);
	}
#endif /* TTSP_INTNO_B */

	i_end_int(TTSP_INTNO_A);
}

#ifdef TTSP_INTNO_B
void inthdr_ttsp_intno_b(void){
	i_begin_int(TTSP_INTNO_B);
	ttsp_clear_int_req(TTSP_INTNO_B);

	ttsp_check_point(12);
	syslog_0(LOG_NOTICE, "ttsp_int_raise(TTSP_INTNO_B) : OK");

#ifdef TTSP_INTNO_C
	/* ����ߤ򵯤��� */
	ttsp_int_raise(TTSP_INTNO_C);
	ttsp_wait_check_point(13);
#else
	ttsp_check_point(13);
#endif /* TTSP_INTNO_C */

	ttsp_check_point(14);

	i_end_int(TTSP_INTNO_B);
}
#endif /* TTSP_INTNO_B */

#ifdef TTSP_INTNO_C
void inthdr_ttsp_intno_c(void){
	i_begin_int(TTSP_INTNO_C);
	ttsp_clear_int_req(TTSP_INTNO_C);

	ttsp_check_point(13);
	syslog_0(LOG_NOTICE, "ttsp_int_raise(TTSP_INTNO_C) : OK");

	i_end_int(TTSP_INTNO_C);
}
#endif /* TTSP_INTNO_C */

#ifdef TTSP_INTNO_D
void isr_ttsp_intno_d(intptr_t exinf){
	ttsp_clear_int_req(TTSP_INTNO_D);

	ttsp_check_point(8);
	syslog_0(LOG_NOTICE, "ttsp_int_raise(TTSP_INTNO_D) : OK");
}
#endif /* TTSP_INTNO_D */

#ifdef TTSP_INTNO_E
void isr_ttsp_intno_e(intptr_t exinf){
	ttsp_clear_int_req(TTSP_INTNO_E);

	ttsp_check_point(9);
	syslog_0(LOG_NOTICE, "ttsp_int_raise(TTSP_INTNO_E) : OK");
}
#endif /* TTSP_INTNO_E */

#ifdef TTSP_INTNO_F
void isr_ttsp_intno_f(intptr_t exinf){
	ttsp_clear_int_req(TTSP_INTNO_F);

	ttsp_check_point(10);
	syslog_0(LOG_NOTICE, "ttsp_int_raise(TTSP_INTNO_F) : OK");
}
#endif /* TTSP_INTNO_F */
