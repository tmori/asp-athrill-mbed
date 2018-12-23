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
#define TTSP_INTNO_A    9	/* ������ֹ�A */
#define TTSP_INTNO_B   10	/* ������ֹ�B */
#define TTSP_INTNO_C   11	/* ������ֹ�C */
#define TTSP_INTNO_D   12	/* ������ֹ�D */
#define TTSP_INTNO_E   13	/* ������ֹ�E */
#define TTSP_INTNO_F   14	/* ������ֹ�F */

/*
 *  ������ֹ�(�۾���)
 */
#define TTSP_INVALID_INTNO  50	/* �������åȤǥ��ݡ��Ȥ��Ƥ��ʤ�������ֹ� */
#define TTSP_NOT_SET_INTNO   1	/* ������׵�饤����Ф��Ƴ����°�������ꤵ��Ƥ��ʤ�������ֹ� */

/*
 *  ����ߥϥ�ɥ��ֹ�(������)
 */
#define TTSP_INHNO_A   TTSP_INTNO_A		/* ����ߥϥ�ɥ��ֹ�A */
#define TTSP_INHNO_B   TTSP_INTNO_B		/* ����ߥϥ�ɥ��ֹ�B */
#define TTSP_INHNO_C   TTSP_INTNO_C		/* ����ߥϥ�ɥ��ֹ�C */

/*
 *  ����ߥϥ�ɥ��ֹ�(�۾���)
 */
#define TTSP_INVALID_INHNO  50

/*
 *  CPU�㳰�ϥ�ɥ��ֹ�(������)
 */
#define TTSP_EXCNO_A  1		/* CPU�㳰ȯ�����Υ���ƥ����Ȥ�return��ǽ(̤���̿��) */
#define TTSP_EXCNO_B  2		/* ���ֹ��CPU�㳰��ȯ��������ƥ��ȥ������Ϥʤ�(SWI) */

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
 *  TTSP�Ѥδؿ�
 */

/*
 *  �ƥ��å����������
 */ 
extern void ttsp_target_stop_tick(void);

/*
 *  �ƥ��å������κƳ�
 */ 
extern void ttsp_target_start_tick(void);

/*
 *  �ƥ��å��ι���
 */
extern void ttsp_target_gain_tick(void);

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
