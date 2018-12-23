/*
 *  TTSP
 *      TOPPERS Test Suite Package
 * 
 *  Copyright (C) 2010-2012 by Center for Embedded Computing Systems
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
 *  $Id: ttsp_target_test.h 2 2012-05-09 02:23:52Z nces-shigihara $
 */

/*
 *		�ƥ��ȥץ����Υ��åװ�¸�����NaviEngine�ѡ�
 */

#include "ttsp_chip_timer.h"

#ifndef TTSP_TARGET_TEST_H
#define TTSP_TARGET_TEST_H


/*
 *  CPU�㳰��ȯ��������̿��
 */
__svc(0) void _svc_dummy(void);

#define RAISE_CPU_EXCEPTION _svc_dummy()

/*
 *  ��ǽɾ���ץ����Τ�������
 */

/*
 *  �����ͥ����������Ƥ���ؿ��γ������
 */
extern void perf_timer_get(uint32_t *p_time);
extern uint32_t perf_timer_conv_tim(uint32_t time);

/*
 *  ��ǽɾ���ѤΥޥ������
 */
#define HISTTIM  uint32_t
#define HIST_GET_TIM(p_time)  perf_timer_get(p_time)
#define HIST_CONV_TIM(time)   perf_timer_conv_tim(time)

/*
 *  ���åװ�¸�⥸�塼���MPCORE�ѡ�
 */
#include "arm_gcc/mpcore/chip_test.h"

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
#define TTSP_HIGH_INTPRI  -5				/* �����ͥ���ٹ� */
#define TTSP_MID_INTPRI   -4				/* �����ͥ������ */
#define TTSP_LOW_INTPRI   -3				/* �����ͥ������ */

/*  
 *  ������ֹ�(������)
 */
#define TTSP_INTNO_A      0x00021	/* PE1������ֹ�A */
#define TTSP_INTNO_B      0x00022	/* PE1������ֹ�B */
#define TTSP_INTNO_C      0x00023	/* PE1������ֹ�C */
#define TTSP_INTNO_D      0x00024	/* PE1������ֹ�D */
#define TTSP_INTNO_E      0x00025	/* PE1������ֹ�E */
#define TTSP_INTNO_F      0x00026	/* PE1������ֹ�F */

#define TTSP_INTNO_PE2_A  0x00027	/* PE2������ֹ�A */
#define TTSP_INTNO_PE2_B  0x00028	/* PE2������ֹ�B */
#define TTSP_INTNO_PE2_C  0x00029	/* PE2������ֹ�C */
#define TTSP_INTNO_PE2_D  0x0002a	/* PE2������ֹ�D */
#define TTSP_INTNO_PE2_E  0x0002b	/* PE2������ֹ�E */
#define TTSP_INTNO_PE2_F  0x0002c	/* PE2������ֹ�F */

#define TTSP_INTNO_PE3_A  0x0002e	/* PE3������ֹ�A */
#define TTSP_INTNO_PE3_B  0x0002f	/* PE3������ֹ�B */
#define TTSP_INTNO_PE3_C  0x00030	/* PE3������ֹ�C */
#define TTSP_INTNO_PE3_D  0x00031	/* PE3������ֹ�D */
#define TTSP_INTNO_PE3_E  0x00032	/* PE3������ֹ�E */
#define TTSP_INTNO_PE3_F  0x00033	/* PE3������ֹ�F */

#define TTSP_INTNO_PE4_A  0x00034	/* PE4������ֹ�A */
#define TTSP_INTNO_PE4_B  0x00035	/* PE4������ֹ�B */
#define TTSP_INTNO_PE4_C  0x00036	/* PE4������ֹ�C */
#define TTSP_INTNO_PE4_D  0x00037	/* PE4������ֹ�D */
#define TTSP_INTNO_PE4_E  0x00038	/* PE4������ֹ�E */
#define TTSP_INTNO_PE4_F  0x00039	/* PE4������ֹ�F */

#define TTSP_GLOBAL_IRC_INTNO_A  0x00009	/* �����Х�IRC�ѳ�����ֹ�A */
#define TTSP_GLOBAL_IRC_INTNO_B  0x0000A	/* �����Х�IRC�ѳ�����ֹ�B */
#define TTSP_GLOBAL_IRC_INTNO_C  0x0000B	/* �����Х�IRC�ѳ�����ֹ�C */
#define TTSP_GLOBAL_IRC_INTNO_D  0x0000C	/* �����Х�IRC�ѳ�����ֹ�D */
#define TTSP_GLOBAL_IRC_INTNO_E  0x0000D	/* �����Х�IRC�ѳ�����ֹ�E */
#define TTSP_GLOBAL_IRC_INTNO_F  0x0000E	/* �����Х�IRC�ѳ�����ֹ�F */

/*
 *  ������ֹ�(�۾���)
 */
#define TTSP_INVALID_INTNO       0x10080	/* PE1�������åȤǥ��ݡ��Ȥ��Ƥ��ʤ�������ֹ� */
#define TTSP_INVALID_INTNO_PE2   0x20080	/* PE2�������åȤǥ��ݡ��Ȥ��Ƥ��ʤ�������ֹ� */
#define TTSP_INVALID_INTNO_PE3   0x30080	/* PE3�������åȤǥ��ݡ��Ȥ��Ƥ��ʤ�������ֹ� */
#define TTSP_INVALID_INTNO_PE4   0x40080	/* PE4�������åȤǥ��ݡ��Ȥ��Ƥ��ʤ�������ֹ� */
#define TTSP_NOT_SET_INTNO       0x10010	/* PE1������׵�饤����Ф��Ƴ����°�������ꤵ��Ƥ��ʤ�������ֹ� */
#define TTSP_NOT_SET_INTNO_PE2   0x20010	/* PE2������׵�饤����Ф��Ƴ����°�������ꤵ��Ƥ��ʤ�������ֹ� */
#define TTSP_NOT_SET_INTNO_PE3   0x30010	/* PE3������׵�饤����Ф��Ƴ����°�������ꤵ��Ƥ��ʤ�������ֹ� */
#define TTSP_NOT_SET_INTNO_PE4   0x40010	/* PE4������׵�饤����Ф��Ƴ����°�������ꤵ��Ƥ��ʤ�������ֹ� */
#define TTSP_NOT_SELF_INTNO_PE1  0x20001	/* PE1��̥ӥåȤ�ȯ�Ը��ץ��å�ID�Ȱۤʤ������ֹ� */
#define TTSP_NOT_SELF_INTNO_PE2  0x10001	/* PE2��̥ӥåȤ�ȯ�Ը��ץ��å�ID�Ȱۤʤ������ֹ� */
#define TTSP_NOT_SELF_INTNO_PE3  0x10001	/* PE3��̥ӥåȤ�ȯ�Ը��ץ��å�ID�Ȱۤʤ������ֹ� */
#define TTSP_NOT_SELF_INTNO_PE4  0x10001	/* PE4��̥ӥåȤ�ȯ�Ը��ץ��å�ID�Ȱۤʤ������ֹ� */

/*
 *  ����ߥϥ�ɥ��ֹ�(������)
 */
#define TTSP_INHNO_A       0x10021		/* PE1����ߥϥ�ɥ��ֹ�A */
#define TTSP_INHNO_B       0x10022		/* PE1����ߥϥ�ɥ��ֹ�B */
#define TTSP_INHNO_C       0x10023		/* PE1����ߥϥ�ɥ��ֹ�C */

#define TTSP_INHNO_PE2_A   0x20027		/* PE2����ߥϥ�ɥ��ֹ�A */
#define TTSP_INHNO_PE2_B   0x20028		/* PE2����ߥϥ�ɥ��ֹ�B */
#define TTSP_INHNO_PE2_C   0x20029		/* PE2����ߥϥ�ɥ��ֹ�C */

#define TTSP_INHNO_PE3_A   0x3002e		/* PE3����ߥϥ�ɥ��ֹ�A */
#define TTSP_INHNO_PE3_B   0x3002f		/* PE3����ߥϥ�ɥ��ֹ�B */
#define TTSP_INHNO_PE3_C   0x30030		/* PE3����ߥϥ�ɥ��ֹ�C */

#define TTSP_INHNO_PE4_A   0x40034		/* PE4����ߥϥ�ɥ��ֹ�A */
#define TTSP_INHNO_PE4_B   0x40035		/* PE4����ߥϥ�ɥ��ֹ�B */
#define TTSP_INHNO_PE4_C   0x40036		/* PE4����ߥϥ�ɥ��ֹ�C */

/*
 *  ����ߥϥ�ɥ��ֹ�(�۾���)
 */
#define TTSP_INVALID_INHNO  -1
#define TTSP_GLOBAL_IRC_INHNO_A  TTSP_GLOBAL_IRC_INTNO_A	/* �����Х�IRC�ѳ���ߥϥ�ɥ��ֹ�A */
#define TTSP_GLOBAL_IRC_INHNO_B  TTSP_GLOBAL_IRC_INTNO_B	/* �����Х�IRC�ѳ���ߥϥ�ɥ��ֹ�B */
#define TTSP_GLOBAL_IRC_INHNO_C  TTSP_GLOBAL_IRC_INTNO_C	/* �����Х�IRC�ѳ���ߥϥ�ɥ��ֹ�C */

/*
 *  CPU�㳰�ϥ�ɥ��ֹ�(������)
 */
#define TTSP_EXCNO_A      (0x10000|EXCH_NO_SWI)		/* CPU�㳰ȯ�����Υ���ƥ����Ȥ�return��ǽ(SWI) */
#define TTSP_EXCNO_B      (0x10000|EXCH_NO_UNDEF)	/* ���ֹ��CPU�㳰��ȯ��������ƥ��ȥ������Ϥʤ�(̤���̿��) */
#define TTSP_EXCNO_PE2_A  (0x20000|EXCH_NO_SWI)		/* PE2SWI */
#define TTSP_EXCNO_PE2_B  (0x20000|EXCH_NO_UNDEF)	/* PE2̤���̿�� */
#define TTSP_EXCNO_PE3_A  (0x30000|EXCH_NO_SWI)		/* PE3SWI */
#define TTSP_EXCNO_PE3_B  (0x30000|EXCH_NO_UNDEF)	/* PE3̤���̿�� */
#define TTSP_EXCNO_PE4_A  (0x40000|EXCH_NO_SWI)		/* PE4SWI */
#define TTSP_EXCNO_PE4_B  (0x40000|EXCH_NO_UNDEF)	/* PE4̤���̿�� */

/*
 *  CPU�㳰�ϥ�ɥ��ֹ�(�۾���)
 */
#define TTSP_INVALID_EXCNO  0


/*
 *  �ƥ����Ѥδؿ�
 */

/*
 *  ��Ʊ�������Υ����ॢ�������ѿ�
 *  [sil_dly_nse(TTSP_SIL_DLY_NSE_TIME) * TTSP_LOOP_COUNT]
 *  �ǥե����: 1�ޥ������� * 3,000,000�� = 3��
 */
#define TTSP_SIL_DLY_NSE_TIME  1000
#define TTSP_LOOP_COUNT        3000000

/*
 *  ����ߤ�ȯ��
 */
extern void ttsp_int_raise(INTNO intno);

/*
 *  CPU�㳰��ȯ��
 */
extern void ttsp_cpuexc_raise(EXCNO excno);

/*
 *  CPU�㳰ȯ�����Υեå�����
 */
extern void ttsp_cpuexc_hook(EXCNO excno, void* p_excinf);

/*
 *  ������׵�Υ��ꥢ
 */
extern void ttsp_clear_int_req(INTNO intno);

#endif /* TTSP_TARGET_TEST_H */
