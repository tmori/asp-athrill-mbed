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

extern void all_test(ID prcid, bool_t int_spn_flg);
extern void part_test(ID prcid, E_TEST_TYPE test_type, bool_t int_spn_flg);

extern void test_of_sil_mem(ID prcid, bool_t ter_flg);
extern void test_of_sil_dly_nse(ID prcid);
extern void test_of_sil_get_pid(ID prcid, bool_t ter_flg);
extern void test_of_sns_ker(ID prcid, bool_t flag, bool_t ter_flg);
extern void test_of_SIL_LOC_INT_SPN(ID prcid, bool_t int_spn_flg);

extern void wait_raise_int(ID prcid);
extern void check_of_sil_mem(void);

#if defined(TTSP_INTNO_B) || defined(TTSP_INTNO_PE2_B) || defined(TTSP_INTNO_PE3_B) || defined(TTSP_INTNO_PE4_B)
extern void inthdr(void);
#endif /* defined(TTSP_INTNO_B) || defined(TTSP_INTNO_PE2_B) || defined(TTSP_INTNO_PE3_B) || defined(TTSP_INTNO_PE4_B) */

#if defined(TTSP_INTNO_C) || defined(TTSP_INTNO_PE2_C) || defined(TTSP_INTNO_PE3_C) || defined(TTSP_INTNO_PE4_C)
extern void isr(intptr_t exinf);
#endif /* defined(TTSP_INTNO_C) || defined(TTSP_INTNO_PE2_C) || defined(TTSP_INTNO_PE3_C) || defined(TTSP_INTNO_PE4_C) */

extern void ttsp_test_lib_init(intptr_t exinf);
