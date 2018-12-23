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
 *  $Id: ttsp_target_test.h 2 2012-05-09 02:23:52Z nces-shigihara $
 */

/*
 *		�ƥ��ȥץ����Υ��åװ�¸�����AT91SKYEYE�ѡ�
 */

#ifndef TTSP_TARGET_TEST_H
#define TTSP_TARGET_TEST_H

/*
 *  ��ǽɾ���ץ����Τ�������
 */

/*
 *  �����ͥ����������Ƥ���ؿ��γ������
 */
extern void cycle_counter_get(uint32_t *p_time);

/*
 *  ��ǽɾ���ѤΥޥ������
 */
#define HISTTIM  uint32_t
#define HIST_GET_TIM(p_time)  cycle_counter_get(p_time)

/*
 *  CPU�㳰��ȯ��������̿��
 */
#if defined(TOPPERS_ENABLE_GCOV_PART) || defined(TOPPERS_ENABLE_GCOV_FULL)
#define RAISE_CPU_EXCEPTION Asm(".long 0x16000010");
#else
#define RAISE_CPU_EXCEPTION Asm(".long 0x06000010");
#endif /* defined(TOPPERS_ENABLE_GCOV_PART) || defined(TOPPERS_ENABLE_GCOV_FULL) */


/*
 *  TTSP�Ѥ����
 */

/*
 *  �������Υ����å�������
 */
#define TTSP_TASK_STACK_SIZE  2048

/*
 *  �󥿥�������ƥ����ȤΥ����å�������
 *  (DEF_ICS�Υƥ��ȤǤΤ߻��Ѥ���)
 */
#define TTSP_NON_TASK_STACK_SIZE  2048

/*
 *  �ؿ�����Ƭ���ϤȤ�������������
 */
#define TTSP_INVALID_FUNC_ADDRESS  0x123456

/*
 *  �����å��ΰ�Ȥ�������������
 */
#define TTSP_INVALID_STK_ADDRESS  0x123456

/*
 *  ����Ĺ���꡼�ס������Ƭ���ϤȤ�������������
 */
#define TTSP_INVALID_MPF_ADDRESS  0x123456

/*
 *  �����å��������Ȥ��������ʥ�����
 */
#define TTSP_INVALID_STACK_SIZE  0x01

/*  
 *  �������å�����γ�ĥ��γ����ͥ���ٺǾ���
 */
#define TTSP_TMIN_INTPRI  TMIN_INTPRI

/*  
 *  �����ͥ�������
 */
#define TTSP_GE_TIMER_INTPRI  TMIN_INTPRI	/* �����޳���ߤγ����ͥ���٤��⤤�����ͥ���� */
#define TTSP_HIGH_INTPRI      -5			/* �����ͥ���ٹ� */
#define TTSP_MID_INTPRI       -4			/* �����ͥ������ */
#define TTSP_LOW_INTPRI       -3			/* �����ͥ������ */

/*  
 *  ������ֹ�(������)
 */
#define TTSP_INTNO_A      0x10009	/* PE1������ֹ�A */
#define TTSP_INTNO_B      0x1000A	/* PE1������ֹ�B */
#define TTSP_INTNO_C      0x1000B	/* PE1������ֹ�C */
#define TTSP_INTNO_D      0x1000C	/* PE1������ֹ�D */
#define TTSP_INTNO_E      0x1000D	/* PE1������ֹ�E */
#define TTSP_INTNO_F      0x1000E	/* PE1������ֹ�F */

#define TTSP_INTNO_PE2_A  0x20009	/* PE2������ֹ�A */
#define TTSP_INTNO_PE2_B  0x2000A	/* PE2������ֹ�B */
#define TTSP_INTNO_PE2_C  0x2000B	/* PE2������ֹ�C */
#define TTSP_INTNO_PE2_D  0x2000C	/* PE2������ֹ�D */
#define TTSP_INTNO_PE2_E  0x2000D	/* PE2������ֹ�E */
#define TTSP_INTNO_PE2_F  0x2000E	/* PE2������ֹ�F */

#define TTSP_INTNO_PE3_A  0x30009	/* PE3������ֹ�A */
#define TTSP_INTNO_PE3_B  0x3000A	/* PE3������ֹ�B */
#define TTSP_INTNO_PE3_C  0x3000B	/* PE3������ֹ�C */
#define TTSP_INTNO_PE3_D  0x3000C	/* PE3������ֹ�D */
#define TTSP_INTNO_PE3_E  0x3000D	/* PE3������ֹ�E */
#define TTSP_INTNO_PE3_F  0x3000E	/* PE3������ֹ�F */

#define TTSP_INTNO_PE4_A  0x40009	/* PE4������ֹ�A */
#define TTSP_INTNO_PE4_B  0x4000A	/* PE4������ֹ�B */
#define TTSP_INTNO_PE4_C  0x4000B	/* PE4������ֹ�C */
#define TTSP_INTNO_PE4_D  0x4000C	/* PE4������ֹ�D */
#define TTSP_INTNO_PE4_E  0x4000D	/* PE4������ֹ�E */
#define TTSP_INTNO_PE4_F  0x4000E	/* PE4������ֹ�F */

/*
 *  ������ֹ�(�۾���)
 */
#define TTSP_INVALID_INTNO       0x10032	/* PE1�������åȤǥ��ݡ��Ȥ��Ƥ��ʤ�������ֹ� */
#define TTSP_INVALID_INTNO_PE2   0x20032	/* PE2�������åȤǥ��ݡ��Ȥ��Ƥ��ʤ�������ֹ� */
#define TTSP_INVALID_INTNO_PE3   0x30032	/* PE3�������åȤǥ��ݡ��Ȥ��Ƥ��ʤ�������ֹ� */
#define TTSP_INVALID_INTNO_PE4   0x40032	/* PE4�������åȤǥ��ݡ��Ȥ��Ƥ��ʤ�������ֹ� */
#define TTSP_NOT_SET_INTNO       0x10001	/* PE1������׵�饤����Ф��Ƴ����°�������ꤵ��Ƥ��ʤ�������ֹ� */
#define TTSP_NOT_SET_INTNO_PE2   0x20001	/* PE2������׵�饤����Ф��Ƴ����°�������ꤵ��Ƥ��ʤ�������ֹ� */
#define TTSP_NOT_SET_INTNO_PE3   0x30001	/* PE3������׵�饤����Ф��Ƴ����°�������ꤵ��Ƥ��ʤ�������ֹ� */
#define TTSP_NOT_SET_INTNO_PE4   0x40001	/* PE4������׵�饤����Ф��Ƴ����°�������ꤵ��Ƥ��ʤ�������ֹ� */
#define TTSP_GLOBAL_IRC_INTNO_A  0x00009	/* �����Х�IRC�ѳ�����ֹ�A(at91skyeye_gcc�Ǥϥ��ݡ��ȳ�) */
#define TTSP_GLOBAL_IRC_INTNO_B  0x0000A	/* �����Х�IRC�ѳ�����ֹ�B(at91skyeye_gcc�Ǥϥ��ݡ��ȳ�) */
#define TTSP_GLOBAL_IRC_INTNO_C  0x0000B	/* �����Х�IRC�ѳ�����ֹ�C(at91skyeye_gcc�Ǥϥ��ݡ��ȳ�) */
#define TTSP_GLOBAL_IRC_INTNO_D  0x0000C	/* �����Х�IRC�ѳ�����ֹ�D(at91skyeye_gcc�Ǥϥ��ݡ��ȳ�) */
#define TTSP_GLOBAL_IRC_INTNO_E  0x0000D	/* �����Х�IRC�ѳ�����ֹ�E(at91skyeye_gcc�Ǥϥ��ݡ��ȳ�) */
#define TTSP_GLOBAL_IRC_INTNO_F  0x0000E	/* �����Х�IRC�ѳ�����ֹ�F(at91skyeye_gcc�Ǥϥ��ݡ��ȳ�) */
#define TTSP_NOT_SELF_INTNO_PE1  0x20001	/* PE1��̥ӥåȤ�ȯ�Ը��ץ��å�ID�Ȱۤʤ������ֹ� */
#define TTSP_NOT_SELF_INTNO_PE2  0x10001	/* PE2��̥ӥåȤ�ȯ�Ը��ץ��å�ID�Ȱۤʤ������ֹ� */
#define TTSP_NOT_SELF_INTNO_PE3  0x10001	/* PE3��̥ӥåȤ�ȯ�Ը��ץ��å�ID�Ȱۤʤ������ֹ� */
#define TTSP_NOT_SELF_INTNO_PE4  0x10001	/* PE4��̥ӥåȤ�ȯ�Ը��ץ��å�ID�Ȱۤʤ������ֹ� */

/*
 *  ����ߥϥ�ɥ��ֹ�(������)
 */
#define TTSP_INHNO_A       TTSP_INTNO_A			/* PE1����ߥϥ�ɥ��ֹ�A */
#define TTSP_INHNO_B       TTSP_INTNO_B			/* PE1����ߥϥ�ɥ��ֹ�B */
#define TTSP_INHNO_C       TTSP_INTNO_C			/* PE1����ߥϥ�ɥ��ֹ�C */

#define TTSP_INHNO_PE2_A   TTSP_INTNO_PE2_A		/* PE2����ߥϥ�ɥ��ֹ�A */
#define TTSP_INHNO_PE2_B   TTSP_INTNO_PE2_B		/* PE2����ߥϥ�ɥ��ֹ�B */
#define TTSP_INHNO_PE2_C   TTSP_INTNO_PE2_C		/* PE2����ߥϥ�ɥ��ֹ�C */

#define TTSP_INHNO_PE3_A   TTSP_INTNO_PE3_A		/* PE3����ߥϥ�ɥ��ֹ�A */
#define TTSP_INHNO_PE3_B   TTSP_INTNO_PE3_B		/* PE3����ߥϥ�ɥ��ֹ�B */
#define TTSP_INHNO_PE3_C   TTSP_INTNO_PE3_C		/* PE3����ߥϥ�ɥ��ֹ�C */

#define TTSP_INHNO_PE4_A   TTSP_INTNO_PE4_A		/* PE4����ߥϥ�ɥ��ֹ�A */
#define TTSP_INHNO_PE4_B   TTSP_INTNO_PE4_B		/* PE4����ߥϥ�ɥ��ֹ�B */
#define TTSP_INHNO_PE4_C   TTSP_INTNO_PE4_C		/* PE4����ߥϥ�ɥ��ֹ�C */

/*
 *  ����ߥϥ�ɥ��ֹ�(�۾���)
 */
#define TTSP_INVALID_INHNO  -1
#define TTSP_GLOBAL_IRC_INHNO_A  TTSP_GLOBAL_IRC_INTNO_A	/* �����Х�IRC�ѳ���ߥϥ�ɥ��ֹ�A(at91skyeye_gcc�Ǥϥ��ݡ��ȳ�) */
#define TTSP_GLOBAL_IRC_INHNO_B  TTSP_GLOBAL_IRC_INTNO_B	/* �����Х�IRC�ѳ���ߥϥ�ɥ��ֹ�B(at91skyeye_gcc�Ǥϥ��ݡ��ȳ�) */
#define TTSP_GLOBAL_IRC_INHNO_C  TTSP_GLOBAL_IRC_INTNO_C	/* �����Х�IRC�ѳ���ߥϥ�ɥ��ֹ�C(at91skyeye_gcc�Ǥϥ��ݡ��ȳ�) */

/*
 *  CPU�㳰�ϥ�ɥ��ֹ�(������)
 */
#define TTSP_EXCNO_A      0x10001	/* CPU�㳰ȯ�����Υ���ƥ����Ȥ�return��ǽ(̤���̿��) */
#define TTSP_EXCNO_B      0x10002	/* ���ֹ��CPU�㳰��ȯ��������ƥ��ȥ������Ϥʤ�(SWI) */
#define TTSP_EXCNO_PE2_A  0x20001	/* PE2̤���̿�� */
#define TTSP_EXCNO_PE2_B  0x20002	/* PE2SWI */
#define TTSP_EXCNO_PE3_A  0x30001	/* PE3̤���̿�� */
#define TTSP_EXCNO_PE3_B  0x30002	/* PE3SWI */
#define TTSP_EXCNO_PE4_A  0x40001	/* PE4̤���̿�� */
#define TTSP_EXCNO_PE4_B  0x40002	/* PE4SWI */

/*
 *  CPU�㳰�ϥ�ɥ��ֹ�(�۾���)
 */
#define TTSP_INVALID_EXCNO  0

/*
 *  �����ॢ�������ѿ�
 *  [sil_dly_nse(TTSP_SIL_DLY_NSE_TIME) * TTSP_LOOP_COUNT]
 *  �ǥե����: 1�ޥ������� * 50,000�� = 50�ߥ���
 *  �����ߥ�졼���Τ����δ�Ū��Ŭ�٤�����Ȥ���
 */
#define TTSP_SIL_DLY_NSE_TIME  1000
#define TTSP_LOOP_COUNT        50000


/*
 *  �ƥ����Ѥδؿ�
 */

/*
 *  �ƥ��å���������ߡ����ץ��å���
 */ 
extern void ttsp_target_stop_tick(void);

/*
 *  �ƥ��å���������ߡ�����ץ��å���
 */ 
extern void ttsp_target_stop_tick_pe(ID prcid);

/*
 *  �ƥ��å������κƳ������ץ��å���
 */ 
extern void ttsp_target_start_tick(void);

/*
 *  �ƥ��å������κƳ�������ץ��å���
 */ 
extern void ttsp_target_start_tick_pe(ID prcid);

/*
 *  �ƥ��å��ι��������ץ��å���
 */
extern void ttsp_target_gain_tick(void);

/*
 *  �ƥ��å��ι���������ץ��å���
 */
extern void ttsp_target_gain_tick_pe(ID prcid, bool_t wait_flg);

/*
 *  �����ޥϥ�ɥ��Ѵؿ�
 */
extern bool_t ttsp_timer_handler_begin_hook(void);
extern void ttsp_timer_handler_end_hook(void);

/*
 *  �����ޥϥ�ɥ�ƤӽФ���λ��ǧ�ؿ�
 */
extern void ttsp_check_timer_handler(void);


/*
 *  ����ߤ�ȯ��
 */
extern void ttsp_int_raise(INTNO intno);

/*
 *  CPU�㳰��ȯ��
 */
extern void ttsp_cpuexc_raise(EXCNO excno);

/*
 *  CPU�㳰ȯ�����Υեå�����(SkyEye�Ǥ�����)
 */
extern void ttsp_cpuexc_hook(EXCNO excno, void* p_excinf);

/*
 *  ������׵�Υ��ꥢ(SkyEye�Ǥ�����)
 */
extern void ttsp_clear_int_req(INTNO intno);

#endif /* TTSP_TARGET_TEST_H */
