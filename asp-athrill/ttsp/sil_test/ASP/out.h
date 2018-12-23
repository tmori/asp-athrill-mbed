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

/*
 *  ����ߤ�ȯ�����ʤ��ä���Ƚ�Ǥ������
 *  (sil_dly_nse()�ΰ����ǻ���)
 */
#define TTSP_WAIT_NOT_RAISE_INT  1000000

/* sil_dly_nse()�ǥƥ��Ȥ����ٱ����  */
#define SIL_DLY_TIME      10000000
#define SIL_DLY_TIME_SUB  SIL_DLY_TIME / 1000000

/* �����ɤ߽񤭤ǻ��Ѥ���ǡ��� */
#define R_DATA8       0x12
#define R_DATA16      0x1234
#define R_DATA32      0x12345678
#define W_DATA8       0x21
#define W_DATA16      0x4321
#define W_DATA32      0x87654321
#define CLEAR32       0x00000000

/* �ƥ���Ƚ��������� */
typedef enum e_test_type {
	CHG_IPM,
	DIS_DSP
} E_TEST_TYPE;

extern void main_task(intptr_t exinf);
extern void texhdr(TEXPTN texptn, intptr_t exinf);
extern void almhdr(intptr_t exinf);
extern void cychdr(intptr_t exinf);
extern void exchdr(void* p_excinf);
extern void inirtn(intptr_t exinf);
extern void terrtn(intptr_t exinf);

extern void inthdr_for_int_test(void);

extern void all_test(void);
extern void part_test(E_TEST_TYPE test_type);

extern void test_of_sil_mem(void);
extern void test_of_sil_dly_nse(void);
extern void test_of_sns_ker(bool_t flag);
extern void test_of_SIL_LOC_INT(void);

extern void wait_raise_int(void);
extern void check_of_sil_mem(void);

#ifdef TTSP_INTNO_B
extern void inthdr(void);
#endif /* TTSP_INTNO_B */

#ifdef TTSP_INTNO_C
extern void isr(intptr_t exinf);
#endif /* TTSP_INTNO_C */
