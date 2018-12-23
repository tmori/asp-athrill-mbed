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
 *  $Id: out.h 2 2012-05-09 02:23:52Z nces-shigihara $
 */

#include "ttsp_target_test.h"

extern void main_task(intptr_t exinf);
extern void texhdr_tex(TEXPTN texptn, intptr_t exinf);

extern void inthdr_ttsp_intno_a(void);

#if defined(TTSP_INTNO_B) || defined(TTSP_INTNO_PE2_B) || defined(TTSP_INTNO_PE3_B) || defined(TTSP_INTNO_PE4_B)
extern void inthdr_ttsp_intno_b(void);
#endif /* defined(TTSP_INTNO_B) || defined(TTSP_INTNO_PE2_B) || defined(TTSP_INTNO_PE3_B) || defined(TTSP_INTNO_PE4_B) */

#if defined(TTSP_INTNO_C) || defined(TTSP_INTNO_PE2_C) || defined(TTSP_INTNO_PE3_C) || defined(TTSP_INTNO_PE4_C)
extern void inthdr_ttsp_intno_c(void);
#endif /* defined(TTSP_INTNO_C) || defined(TTSP_INTNO_PE2_C) || defined(TTSP_INTNO_PE3_C) || defined(TTSP_INTNO_PE4_C) */

#if defined(TTSP_INTNO_D) || defined(TTSP_INTNO_PE2_D) || defined(TTSP_INTNO_PE3_D) || defined(TTSP_INTNO_PE4_D)
extern void isr_ttsp_intno_d(intptr_t exinf);
#endif /* defined(TTSP_INTNO_D) || defined(TTSP_INTNO_PE2_D) || defined(TTSP_INTNO_PE3_D) || defined(TTSP_INTNO_PE4_D) */

#if defined(TTSP_INTNO_E) || defined(TTSP_INTNO_PE2_E) || defined(TTSP_INTNO_PE3_E) || defined(TTSP_INTNO_PE4_E)
extern void isr_ttsp_intno_e(intptr_t exinf);
#endif /* defined(TTSP_INTNO_E) || defined(TTSP_INTNO_PE2_E) || defined(TTSP_INTNO_PE3_E) || defined(TTSP_INTNO_PE4_E) */

#if defined(TTSP_INTNO_F) || defined(TTSP_INTNO_PE2_F) || defined(TTSP_INTNO_PE3_F) || defined(TTSP_INTNO_PE4_F)
extern void isr_ttsp_intno_f(intptr_t exinf);
#endif /* defined(TTSP_INTNO_F) || defined(TTSP_INTNO_PE2_F) || defined(TTSP_INTNO_PE3_F) || defined(TTSP_INTNO_PE4_F) */

extern void ttsp_test_lib_init(intptr_t exinf);
