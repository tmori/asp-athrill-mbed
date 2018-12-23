#
#  TTSP
#      TOPPERS Test Suite Package
# 
#  Copyright (C) 2009-2011 by Center for Embedded Computing Systems
#              Graduate School of Information Science, Nagoya Univ., JAPAN
#  Copyright (C) 2009-2011 by Digital Craft Inc.
#  Copyright (C) 2009-2011 by NEC Communication Systems, Ltd.
#  Copyright (C) 2009-2011 by FUJISOFT INCORPORATED
# 
#  �嵭����Ԥϡ��ʲ���(1)���(4)�ξ������������˸¤ꡤ�ܥ��եȥ���
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
PROCESSOR_NUM=4

#
# �����ޥ������ƥ�����(FMP�����ͥ�Τ߻���)
# [local : �����륿����������global : �����Х륿��������]
#
TIMER_ARCH="local"

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
CONFIG_OPT=

#
# �������åȰ�¸����KERNEL_COBJS���ɲä��륪�֥������ȥե�����
#
KERNEL_COBJS_TARGET="prc_config.o target_config.o target_timer.o target_serial.o ttsp_target_test.o"

#
# make depend / make ���ɲå��ץ����(ɬ�פʾ��Τ�)
# (�����ơ�������ޤ४�ץ����ϻ����Բ�(��:"-d \"dir1 dir2\""))
#
MAKE_OPT=

#
# �¹ԥ⥸�塼��μ¹Ԥ򥷥��륹����ץȤǼ����Ѥߤ�
# [true : �����Ѥߡ�false : �������Ƥ��ʤ�]
# (true�ξ�硤ttb.sh��"e: Run executable module (Target Dependent)"��
#  ���򤹤�ȡ��ʲ��δؿ�simulation()���¹Ԥ����)
#
EXC_MODULE="true"

#
# �¹ԥ⥸�塼��μ¹�(�������åȰ�¸)
# (EXC_MODULE��true�ξ��˼¹Ԥ����)
#
simulation()
{
	# skyeye�����
	MODULE_NAME="asp.exe"
	SKYEYE_EXE="skyeye.exe"
	SKYEYE_CONF="../target/at91skyeye_gcc/skyeye.conf"

	# ���顼��å�����
	ERR_SKYEYE_PATH="Need to pass a path to skyeye"


	which $SKYEYE_EXE &> /dev/null
	if [ $? -eq 1 ]
	then
		echo "$ERR_SKYEYE_PATH"
		return
	fi
	check_file_name=$MODULE_NAME
	check_file
	if [ $? -eq 1 ]
	then
		return
	fi

	skyeye_conf="$TTSP_DIR/$SKYEYE_CONF"
	get_log_time
	get_log_file_name
	create_log_file

	script -c "$SKYEYE_EXE -c $skyeye_conf -e $MODULE_NAME" -a $LOGFILE

	sed -i "s/\r\r\n/\r\n/g" $LOGFILE
	if [ "$kind" = "$SCRATCH" ]
	then
		success=`grep "All" $LOGFILE | wc -l`
		success_num=`expr $success_num + $success`
	fi
}

# ���ּ���
get_log_time()
{
	LOGTIME=`date '+%Y-%m-%d_%H-%M-%S'`
}

# ���ե�����̾����
get_log_file_name()
{
	LOGFILE=`echo "skyeye_"$LOGTIME".log"`
}

# ���ե���������
create_log_file()
{
	echo $SINGLE_LINE >> $LOGFILE
	echo $dir_name >> $LOGFILE
	echo $SINGLE_LINE >> $LOGFILE
}

# ������å������ɥƥ��Ȥη�̽���
output_scr_test_result()
{
	header_single "$TEST_RESULT"
	echo "$NUM_OF_TEST: "$test_num
	echo "$NUM_OF_ALL_PASS: "$success_num
}
