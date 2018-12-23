/*
 *  TTSP
 *      TOPPERS Test Suite Package
 * 
 *  Copyright (C) 2010-2011 by Center for Embedded Computing Systems
 *              Graduate School of Information Science, Nagoya Univ., JAPAN
 *  Copyright (C) 2010-2011 by Digital Craft Inc.
 *  Copyright (C) 2010-2011 by NEC Communication Systems, Ltd.
 *  Copyright (C) 2010-2011 by FUJISOFT INCORPORATED
 *  Copyright (C) 2010-2012 by Industrial Technology Institute,
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
 *		�ƥ��ȥץ����Υ������åȰ�¸�����APSH2AD�ѡ�
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
#define TTSP_HIGH_INTPRI  (-5)	/* �����ͥ���ٹ� */
#define TTSP_MID_INTPRI   (-4)	/* �����ͥ������ */
#define TTSP_LOW_INTPRI   (-3)	/* �����ͥ������ */

/*  
 *  ������ֹ�(������)
 */
							/*  CMI0_VECTOR�ϥ����ͥ뤬����  */
#define TTSP_INTNO_A      (0x10000 | CMI1_VECTOR)	/* PE1������ֹ�A */
#define TTSP_INTNO_B      (0x10000 | CMI2_VECTOR)	/* PE1������ֹ�B */
#define TTSP_INTNO_C      (0x10000 | CMI3_VECTOR)	/* PE1������ֹ�C */
													/* PE1������ֹ�D */
#define TTSP_INTNO_D      (0x10000 | MTU0_TGI0V_VECTOR)

#define TTSP_INTNO_PE2_A  (0x20000 | MTU1_TGI1V_VECTOR)	/* PE2������ֹ�A */
#define TTSP_INTNO_PE2_B  (0x20000 | MTU2_TGI2V_VECTOR)	/* PE2������ֹ�B */
#define TTSP_INTNO_PE2_C  (0x20000 | MTU3_TGI3V_VECTOR)	/* PE2������ֹ�C */
#define TTSP_INTNO_PE2_D  (0x20000 | MTU4_TGI4V_VECTOR)	/* PE2������ֹ�D */

/*
 *  ������ֹ�(�۾���)
 */
#define TTSP_INVALID_INTNO   0x10001	/* �������åȤǥ��ݡ��Ȥ��Ƥ��ʤ�������ֹ� */
					/* ������׵�饤����Ф��Ƴ����°�������ꤵ��Ƥ��ʤ�������ֹ� */
#define TTSP_NOT_SET_INTNO   	(0x10000 | 68)		/* ������PE1������ֹ� */
#define TTSP_INVALID_INTNO_PE2	(0x20000 | 68)		/* ������PE2������ֹ� */
#define TTSP_NOT_SELF_INTNO_PE1  0x20001	/* PE1��̥ӥåȤ�ȯ�Ը��ץ��å�ID�Ȱۤʤ������ֹ� */
#define TTSP_NOT_SELF_INTNO_PE2  0x10001	/* PE2��̥ӥåȤ�ȯ�Ը��ץ��å�ID�Ȱۤʤ������ֹ� */

/*  �����Х�IRC�ѳ�����ֹ�ʤ��Υ������åȤǤϥ��ݡ��ȳ���  */
#define TTSP_GLOBAL_IRC_INTNO_A  CMI1_VECTOR	/* �����Х�IRC�ѳ�����ֹ�A */
#define TTSP_GLOBAL_IRC_INTNO_B  CMI2_VECTOR	/* �����Х�IRC�ѳ�����ֹ�B */
#define TTSP_GLOBAL_IRC_INTNO_C  CMI3_VECTOR	/* �����Х�IRC�ѳ�����ֹ�C */

/*
 *  ����ߥϥ�ɥ��ֹ�(������)
 */
#define TTSP_INHNO_A       TTSP_INTNO_A			/* PE1����ߥϥ�ɥ��ֹ�A */
#define TTSP_INHNO_B       TTSP_INTNO_B			/* PE1����ߥϥ�ɥ��ֹ�B */
#define TTSP_INHNO_C       TTSP_INTNO_C			/* PE1����ߥϥ�ɥ��ֹ�C */
#define TTSP_INHNO_D       TTSP_INTNO_D			/* PE1����ߥϥ�ɥ��ֹ�D */

#define TTSP_INHNO_PE2_A   TTSP_INTNO_PE2_A		/* PE2����ߥϥ�ɥ��ֹ�A */
#define TTSP_INHNO_PE2_B   TTSP_INTNO_PE2_B		/* PE2����ߥϥ�ɥ��ֹ�B */
#define TTSP_INHNO_PE2_C   TTSP_INTNO_PE2_C		/* PE2����ߥϥ�ɥ��ֹ�C */
#define TTSP_INHNO_PE2_D   TTSP_INTNO_PE2_D		/* PE2����ߥϥ�ɥ��ֹ�D */

/*
 *  ����ߥϥ�ɥ��ֹ�(�۾���)
 */
#define TTSP_INVALID_INHNO  TTSP_INVALID_INTNO

/*
 *  CPU�㳰�ϥ�ɥ��ֹ�(������)
 */
										/* CPU�㳰ȯ�����Υ���ƥ����Ȥ�return��ǽ */
#define TTSP_EXCNO_A 		0x10009		/* ���ɥ쥹���顼�㳰 */
#define TTSP_EXCNO_B  		0x10004		/*  ��������̿��  */
										/* ���ֹ��CPU�㳰��Ͽ���뤬��*/
										/* �ºݤ�CPU�㳰��ȯ�������� */
										/* �ƥ��ȥ������Ϥʤ� */
#define TTSP_EXCNO_PE2_A  	0x20009		/* PE2�����ɥ쥹���顼�㳰 */
#define TTSP_EXCNO_PE2_B  	0x20004		/* PE2����������̿�� */


/*
 *  CPU�㳰�ϥ�ɥ��ֹ�(�۾���)
 */
#define TTSP_INVALID_EXCNO  0x10005


/*
 *  TTSP�Ѥδؿ�
 */

/*
 *  ��Ʊ�������Υ����ॢ�������ѿ�
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
 *  �ƥ��å��ι���������ץ��å���
 *  �������Х륿���������ʤΤǡ�
 *  ��prcid�ˤϻ�������ץ��å��������ꤷ�ʤ���
 */
extern void ttsp_target_gain_tick_pe(ID prcid, bool_t wait_flg);

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
