/*
 *  TTSP
 *      Toyohashi Open Platform for Embedded Real-Time Systems
 *      Test Suite Package
 * 
 *  Copyright (C) 2010-2011 by Center for Embedded Computing Systems
 *              Graduate School of Information Science, Nagoya Univ., JAPAN
 *  Copyright (C) 2010-2011 by Digital Craft Inc.
 *  Copyright (C) 2010-2011 by NEC Communication Systems, Ltd.
 *  Copyright (C) 2010-2011 by FUJISOFT INCORPORATED
 *	Copyright (C) 2010-2012 by Industrial Technology Institute,
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
 *  $Id: ttsp_target_test.h 2 2012-05-09 02:23:52Z nces-shigihara $
 */

/*
 *		�ƥ��ȥץ����Υ������åȰ�¸�����apsh2a_gcc�ѡ�
 */

#ifndef TTSP_TARGET_TEST_H
#define TTSP_TARGET_TEST_H

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
#define TTSP_INVALID_FUNC_ADDRESS  0x123451	/*  2�Х��ȶ����Ǥʤ�  */

/*
 *  �����å��ΰ�Ȥ�������������
 */
#define TTSP_INVALID_STK_ADDRESS  0x123456	/*  4�Х��ȶ����Ǥʤ�  */

/*
 *  ����Ĺ���꡼�ס������Ƭ���ϤȤ�������������
 */
#define TTSP_INVALID_MPF_ADDRESS  0x123456	/*  4�Х��ȶ����Ǥʤ�  */

/*
 *  �����å��������Ȥ��������ʥ�����
 */
#define TTSP_INVALID_STACK_SIZE  0x123456	/*  4�Х��Ȥ��ܿ��Ǥʤ�  */

/*  
 *  �������å�����γ�ĥ��γ����ͥ���ٺǾ���
 */
#define TTSP_TMIN_INTPRI  TMIN_INTPRI

/*  
 *  �����ͥ�������
 */
#define TTSP_GE_TIMER_INTPRI  TMIN_INTPRI	/* �����޳���ߤγ����ͥ���٤��⤤�����ͥ���� */
#define TTSP_HIGH_INTPRI  -5	/* �����ͥ���ٹ� */
#define TTSP_MID_INTPRI   -4	/* �����ͥ������ */
#define TTSP_LOW_INTPRI   -3	/* �����ͥ������ */

/*  
 *  ������ֹ�(������)
 */
#define TTSP_INTNO_A   CMI1_VECTOR			/* ������ֹ�A */
#define TTSP_INTNO_B   MTU0_TGI0V_VECTOR	/* ������ֹ�B */
#define TTSP_INTNO_C   MTU1_TGI1V_VECTOR	/* ������ֹ�C */
#define TTSP_INTNO_D   MTU2_TGI2V_VECTOR	/* ������ֹ�D */
#define TTSP_INTNO_E   MTU3_TGI3V_VECTOR	/* ������ֹ�E */
#define TTSP_INTNO_F   MTU4_TGI4V_VECTOR	/* ������ֹ�F */

/*
 *  ������ֹ�(�۾���)
 */
#define TTSP_INVALID_INTNO   0x001	/* �������åȤǥ��ݡ��Ȥ��Ƥ��ʤ�������ֹ� */
#define TTSP_NOT_SET_INTNO   68		/* �׸�Ƥ��������׵�饤����Ф��Ƴ����°�������ꤵ��Ƥ��ʤ�������ֹ� */

/*
 *  ����ߥϥ�ɥ��ֹ�(������)
 */
#define TTSP_INHNO_A   TTSP_INTNO_A		/* ����ߥϥ�ɥ��ֹ�A */
#define TTSP_INHNO_B   TTSP_INTNO_B		/* ����ߥϥ�ɥ��ֹ�B */
#define TTSP_INHNO_C   TTSP_INTNO_C		/* ����ߥϥ�ɥ��ֹ�C */
#define TTSP_INHNO_D   TTSP_INTNO_D		/* ����ߥϥ�ɥ��ֹ�D */
#define TTSP_INHNO_E   TTSP_INTNO_E		/* ����ߥϥ�ɥ��ֹ�E */
#define TTSP_INHNO_F   TTSP_INTNO_F		/* ����ߥϥ�ɥ��ֹ�F */

/*
 *  ����ߥϥ�ɥ��ֹ�(�۾���)
 */
#define TTSP_INVALID_INHNO  TTSP_INVALID_INTNO

/*
 *  CPU�㳰�ϥ�ɥ��ֹ�(������)
 */
#define TTSP_EXCNO_A 		9		/* ���ɥ쥹���顼�㳰 */
#define TTSP_EXCNO_B  		4		/* ���ֹ��CPU�㳰��Ͽ���뤬��*/
									/* �ºݤ�CPU�㳰��ȯ�������� */
									/* �ƥ��ȥ������Ϥʤ� */

/*
 *  CPU�㳰�ϥ�ɥ��ֹ�(�۾���)
 */
#define TTSP_INVALID_EXCNO  5


/*
 *  TTSP�Ѥδؿ�
 */

/*
 *  �����ॢ�������ѿ�
 *  [sil_dly_nse(TTSP_SIL_DLY_NSE_TIME) * TTSP_LOOP_COUNT]
 *  �ǥե����: 1�ޥ������� * 3,000,000�� = 3��
 */
#define TTSP_SIL_DLY_NSE_TIME  1000
#define TTSP_LOOP_COUNT        3000000

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
 *  ������׵�Υ��ꥢ
 */
extern void ttsp_clear_int_req(INTNO intno);

/*
 *  CPU�㳰��ȯ��
 */
extern void ttsp_cpuexc_raise(EXCNO excno);

/*
 *  CPU�㳰ȯ�����Υեå�����
 */
extern void ttsp_cpuexc_hook(EXCNO excno, void* p_excinf);

/*
 *  ���������������ƥ����ȥ֥�å��Υǡ�����¤�ΰ㤤��
 *  �Ѵ�����ޥ���
 *  
 *  ��USE_TSKINICTXB��������Ƥ��륿�����åȤǤ�
 *  ���ʲ����Ѵ��ޥ���ɬ��
 */
#define ttsp_target_get_stksz(p_tinib)	((p_tinib)->tskinictxb.stksz)
#define ttsp_target_get_stk(p_tinib)	(((p_tinib)->tskinictxb.stk_bottom) \
										 - ((p_tinib)->tskinictxb.stksz))


#endif /* TTSP_TARGET_TEST_H */
