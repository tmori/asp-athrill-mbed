#!/bin/sh
#
#  TTSP
#      TOPPERS Test Suite Package
# 
#  Copyright (C) 2009-2012 by Center for Embedded Computing Systems
#              Graduate School of Information Science, Nagoya Univ., JAPAN
#  Copyright (C) 2009-2011 by Digital Craft Inc.
#  Copyright (C) 2009-2011 by NEC Communication Systems, Ltd.
#  Copyright (C) 2009-2012 by FUJISOFT INCORPORATED
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
#  $Id: ttb.sh 2 2012-05-09 02:23:52Z nces-shigihara $
# 

# �����ȼ¹ԥ����å�
chk=`dirname $0`
if [ $chk != "." ]
then
	echo "Need to execute at a directory of existing \"ttb.sh\""
	exit 1
fi

# ttsp�ե���������Хѥ�
TTSP_DIR=`pwd`

# TTB�¹Ԥ�ɬ�פʥե����
NECESSARY_DIR="\
api_test \
library \
scripts \
sil_test \
tools"

# TTB�¹Ԥ�ɬ�פʥե������̵ͭ������å�
for dir in ${NECESSARY_DIR[@]}
do
	if [ ! -d $dir ]
	then
		echo "$dir is necessary directory"
		exit 1
	fi
done

# ����ե�������ɹ���
source ./scripts/common.sh
source ./configure.sh

# TTB�������åȰ�¸����ե�����Υ��󥯥롼��
source ./library/$PROFILE_NAME/target/$TARGET_NAME/ttsp_target.sh

#
# �ץ�ե������������
#
if [ $PROFILE_NAME = "ASP" ]
then
	API_TEST_DIR="api_test/ASP"
	SIL_TEST_DIR="sil_test/ASP"
	KERNEL_COBJS_COMMON="startup.o task.o wait.o time_event.o task_manage.o task_refer.o task_sync.o task_except.o semaphore.o eventflag.o dataqueue.o pridataq.o mailbox.o mempfix.o time_manage.o cyclic.o alarm.o sys_manage.o interrupt.o exception.o"
elif [ $PROFILE_NAME = "FMP" ]
then
	API_TEST_DIR="api_test"
	SIL_TEST_DIR="sil_test/FMP"
	CONFIG_PRC="-P $PROCESSOR_NUM"
	KERNEL_COBJS_COMMON="startup.o task.o wait.o time_event.o task_manage.o task_refer.o task_sync.o task_except.o semaphore.o eventflag.o dataqueue.o pridataq.o mailbox.o mempfix.o time_manage.o cyclic.o alarm.o sys_manage.o interrupt.o exception.o spin_lock.o mp.o"
else
	echo "$ERR_PROFILE_INVALID ($PROFILE_NAME)"
	exit 1
fi

#
# INCLUDE�оݤΥѥ����
#
TTSP_DIR_NAME=${TTSP_DIR##*/}

TEST_LIB_FILE="ttsp_test_lib.o"
INCLUDE_DIR=`echo '\$(SRCDIR)/'$TTSP_DIR_NAME'/library/'$PROFILE_NAME'/test \$(SRCDIR)/'$TTSP_DIR_NAME'/library/'$PROFILE_NAME'/target/'$TARGET_NAME`
ARCH_DIR=`echo '\$(SRCDIR)/'$TTSP_DIR_NAME'/library/'$PROFILE_NAME'/arch'`
for dir in ${ARCH_PATH[@]}
do
	INCLUDE_DIR=`echo "$INCLUDE_DIR $ARCH_DIR/$dir"`
done


#
# configure���ץ����
#
CONFIG_KERNEL_LIB=`echo "-T $TARGET_NAME -U $TEST_LIB_FILE $CONFIG_PRC $CONFIG_OPT -a "`
if [ $USE_KERNEL_LIB = true ]
then
	CONFIG_TEST_PROGRAM=`echo '-T '$TARGET_NAME' -A '$APPLI_NAME' -L \$(SRCDIR)/'$TTSP_DIR_NAME'/'$KERNEL_LIB' -U '$TEST_LIB_FILE $CONFIG_PRC $CONFIG_OPT' -a'`
elif [ $USE_KERNEL_LIB = false ]
then
	CONFIG_TEST_PROGRAM=`echo '-T '$TARGET_NAME' -A '$APPLI_NAME' -U '$TEST_LIB_FILE $CONFIG_PRC $CONFIG_OPT' -a'`
else
	echo "$ERR_USE_KER_LIB_INVALID ($USE_KERNEL_LIB)"
	exit 1
fi

# TTSP�ᥤ���˥塼
ttsp_main_menu()
{
	go_main_flg=0
	go_api_test_flg=0

	check_makefile

	while true
	do
		cat<<EOS

$DOUBLE_LINE
 $MAIN_MENU
$DOUBLE_LINE
 1: $API_TEST_MENU
 2: $SIL_TEST_MENU
 c: $CHECK_LIBRARY_MENU
 k: $KERNEL_LIBRARY_MENU
 q: $EXIT_TOOL
$SINGLE_LINE
EOS
echo -n " $INPUT_NO "
		# �����ɤ߹���
		read key
		echo ""
		# �ɤ߹���������ˤ�ä�ʬ��
		case ${key} in
			1)
			 source ./scripts/api_test.sh
			 ;;
			2)
			 source ./scripts/sil_test.sh
			 ;;
			c)
			 source ./scripts/check_library.sh
			 ;;
			k)
			 source ./scripts/kernel_lib.sh
			 ;;
			q)
			 exit 0
			 ;;
			*)
			 echo " $key $ERR_INVALID_NO"
			 ;;
		esac
	done
	exit 0
}

# ��������
ttsp_main_menu
