#
#  TTSP
#      TOPPERS Test Suite Package
# 
#  Copyright (C) 2009-2011 by Center for Embedded Computing Systems
#              Graduate School of Information Science, Nagoya Univ., JAPAN
#  Copyright (C) 2009-2011 by Digital Craft Inc.
#  Copyright (C) 2009-2011 by NEC Communication Systems, Ltd.
#  Copyright (C) 2009-2011 by FUJISOFT INCORPORATED
#  Copyright (C) 2011 by Industrial Technology Institute,
#								Miyagi Prefectural Government, JAPAN
# 
#  �嵭����Ԥϡ��ʲ���(1)��(4)�ξ������������˸¤ꡤ�ܥ��եȥ���
#  �����ܥ��եȥ���������Ѥ�����Τ�ޤࡥ�ʲ�Ʊ���ˤ���ѡ�ʣ������
#  �ѡ������ۡʰʲ������ѤȸƤ֡ˤ��뤳�Ȥ�̵���ǵ������롥
#  (1) �ܥ��եȥ������򥽡��������ɤη������Ѥ�����ˤϡ��嵭������
#      ��ɽ�����������Ѿ�浪��Ӳ�����̵�ݾڵ��꤬�����Τޤޤη��ǥ���
#      ����������˴ޤޤ�Ƥ��뤳�ȡ�
#  (2) �ܥ��եȥ������򡤥饤�֥������ʤɡ�¾�Υ��եȥ�������ȯ�˻�
#      �ѤǤ�����Ǻ����ۤ�����ˤϡ������ۤ�ȼ���ɥ�����ȡ�����
#      �ԥޥ˥奢��ʤɡˤˡ��嵭�����ɽ�����������Ѿ�浪��Ӳ���
#      ��̵�ݾڵ����Ǻܤ��뤳�ȡ�
#  (3) �ܥ��եȥ������򡤵�����Ȥ߹���ʤɡ�¾�Υ��եȥ�������ȯ�˻�
#      �ѤǤ��ʤ����Ǻ����ۤ�����ˤϡ����Τ����줫�ξ�����������
#      �ȡ�
#    (a) �����ۤ�ȼ���ɥ�����ȡ����Ѽԥޥ˥奢��ʤɡˤˡ��嵭����
#        �ɽ�����������Ѿ�浪��Ӳ�����̵�ݾڵ����Ǻܤ��뤳�ȡ�
#    (b) �����ۤη��֤��̤�������ˡ�ˤ�äơ�TOPPERS�ץ������Ȥ�
#        ��𤹤뤳�ȡ�
#  (4) �ܥ��եȥ����������Ѥˤ��ľ��Ū�ޤ��ϴ���Ū�������뤤���ʤ�»
#      ������⡤�嵭����Ԥ����TOPPERS�ץ������Ȥ����դ��뤳�ȡ�
#      �ޤ����ܥ��եȥ������Υ桼���ޤ��ϥ���ɥ桼������Τ����ʤ���
#      ͳ�˴�Ť����ᤫ��⡤�嵭����Ԥ����TOPPERS�ץ������Ȥ�
#      ���դ��뤳�ȡ�
# 
#  �ܥ��եȥ������ϡ�̵�ݾڤ��󶡤���Ƥ����ΤǤ��롥�嵭����Ԥ�
#  ���TOPPERS�ץ������Ȥϡ��ܥ��եȥ������˴ؤ��ơ�����λ�����Ū
#  ���Ф���Ŭ������ޤ�ơ������ʤ��ݾڤ�Ԥ�ʤ����ޤ����ܥ��եȥ���
#  �������Ѥˤ��ľ��Ū�ޤ��ϴ���Ū�������������ʤ�»���˴ؤ��Ƥ⡤��
#  ����Ǥ�����ʤ���
# 
#  $Id: ttsp_target.sh 2 2012-05-09 02:23:52Z nces-shigihara $
# 

#
# ���ץꥱ�������̾
#
APPLI_NAME="out"

#
# �������ƥ�����ե����(ttsp/library/ASP(FMP)/arch�۲��λ��Ѥ���ե����)�����
# (ɬ�פʾ��Τ�)
# (ʣ�������ǽ��ʣ�����ꤹ����ϥ��ڡ����Ƕ��ڤ�)
#  ��) "arm_gcc/mpcore arm_gcc/common"
#
ARCH_PATH=

#
# �ץ��å���(FMP�����ͥ�Τ߻���)
#
PROCESSOR_NUM=2

#
# �����ޥ������ƥ�����(FMP�����ͥ�Τ߻���)
# [local : �����륿����������global : �����Х륿��������]
#
TIMER_ARCH="global"

#
# �������åȰ�¸API��̵ͭ
# [true: ͭ�ꡤfalse: ̵��]
#
FUNC_TIME="true"		# �����ƥ��������ؿ�
FUNC_INTERRUPT="true"	# �����ȯ���ؿ�
FUNC_EXCEPTION="true"	# CPU�㳰ȯ���ؿ�

#
# IRC�������ƥ�����(FMP�����ͥ�Τ߻���)
# [local: ������IRC�Τߥ��ݡ��ȡ�global: �����Х�IRC�Τߥ��ݡ��ȡ�
#   combination: ������IRC�������Х�IRCξ�����ݡ���]
#
IRC_ARCH="local"

#
# TTG�ؤ��ɲå��ץ����
# (-a��-f��-c��--prc_num��--timer_arch��--out_file_name��--func_time��
#  --func_interrupt��--func_exception, --irc_arch�ϻ����Բġ��ܺ٤�ttsp/user.txt�򻲾�)
#
TTG_OPT=

#
# ����ե�����졼���ؤ��ɲå��ץ����(ɬ�פʾ��Τ�)
# (-T, -A, -U, -a, -L��TTSP�ǻ��Ѥ��뤿������Բ�)
# (�����ơ�������ޤ४�ץ����ϻ����Բ�(��:"-d \"dir1 dir2\""))
#
CONFIG_OPT=-s

#
# �������åȰ�¸����KERNEL_COBJS���ɲä��륪�֥������ȥե�����
#
KERNEL_COBJS_TARGET="ttsp_target_test.o ttsp_target_mtu2.o target_config.o sh2a_dual_config.o prc_cmt.o prc_config.o"

#
# make depend / make ���ɲå��ץ����(ɬ�פʾ��Τ�)
# (�����ơ�������ޤ४�ץ����ϻ����Բ�(��:"-d \"dir1 dir2\""))
#
# �׸�Ƥ����Ŭ�����ץ����-O2
#
MAKE_OPT="COPTS=-DOMIT_TARGET_TIMER_HANDLER COPTS+=-Wall COPTS+=-g"

#
# �¹ԥ⥸�塼��μ¹Ԥ򥷥��륹����ץȤǼ����Ѥߤ�
# [true : �����Ѥߡ�false : �������Ƥ��ʤ�]
# (true�ξ�硤ttb.sh��"e: Run executable module (Target Dependent)"��
#  ���򤹤�ȡ��ʲ��δؿ�simulation()���¹Ԥ����)
#
EXC_MODULE="false"

#
# �¹ԥ⥸�塼��μ¹�(�������åȰ�¸)
# (EXC_MODULE��true�ξ��˼¹Ԥ����)
#
simulation()
{
	echo "$NOT_SUPPORT"
}
