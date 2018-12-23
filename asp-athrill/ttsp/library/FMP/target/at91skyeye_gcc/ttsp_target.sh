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
KERNEL_COBJS_TARGET="core_config.o target_config.o ttsp_target_timer.o ttsp_target_test.o"

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
	# skyeye���
	MODULE_NAME="fmp.exe"
	SKYEYE_EXE="skyeye.exe"
	SKYEYE_CONF_PATH="../target/at91skyeye_gcc"

	# 
	# �ץ��å���˼¹Ԥ��뤿�ᡤcygstart(cygwin)���⤷����rxvt����Ѥ���
	# �¹ԥ⥸�塼���¹Ԥ���
	# c : cygstart�ˤ��skyeye�¹�
	# r : rxvt�ˤ��skyeye�¹�
	#
	TERMINAL_SEL="c"
	RXVT_OPT="-geometry 80x30 -font FixedSys -bg black -fg white"

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

	get_skyeye_conf
	which_sh=`which sh`
	which_script=`which script`
	get_log_time
	get_log_file_name
	create_log_file

	if [ $PROCESSOR_NUM -gt 1 ]
	then
		prc_num=$PROCESSOR_NUM
		while [ $prc_num -gt 0 ]
		do
			echo "$which_script -c \"$SKYEYE_EXE -c ${arr_skyeye_conf[$prc_num]} -e $MODULE_NAME\" -a ${arr_logfile[$prc_num]}" > pe${prc_num}_script.sh
			echo "exit" >> "pe"$prc_num"_script.sh"
			prc_num=`expr $prc_num - 1`
		done
		echo "exit" >> pe1_script.sh
	else
		echo "$which_script -c \"$SKYEYE_EXE -c ${arr_skyeye_conf[0]} -e $MODULE_NAME\" -a ${arr_logfile[1]}" > pe1_script.sh
		echo "exit" >> pe1_script.sh
		echo "exit" >> pe1_script.sh
	fi
	if [ $TERMINAL_SEL = "r" ]
	then
		if [ $PROCESSOR_NUM -gt 1 ]
		then
			prc_num=$PROCESSOR_NUM
			while [ $prc_num -gt 1 ]
			do
				echo "rxvt $RXVT_OPT -title PE$prc_num -e sh pe${prc_num}_script.sh &" > pe${prc_num}_rxvt.sh
				sh ./pe${prc_num}_rxvt.sh
				prc_num=`expr $prc_num - 1`
			done
			wait_skyeye `expr $PROCESSOR_NUM - 1`
			sleep 1
			rxvt $RXVT_OPT -title "PE1" -e sh pe1_script.sh
			sleep 1
		else
			rxvt $RXVT_OPT -title "PE1" -e sh pe1_script.sh
		fi
		kill_proc "rxvt"
	else
		if [ $PROCESSOR_NUM -gt 1 ]
		then
			prc_num=$PROCESSOR_NUM
			while [ $prc_num -gt 1 ]
			do
				cygstart --shownoactivate $which_sh "./pe"$prc_num"_script.sh"
				prc_num=`expr $prc_num - 1`
			done
			wait_skyeye `expr $PROCESSOR_NUM - 1`
			sleep 1
			cygstart -w --shownoactivate $which_sh ./pe1_script.sh
			sleep 1
		else
			cygstart -w --shownoactivate $which_sh ./pe1_script.sh
		fi
		kill_proc "cygstart"
	fi
	prc_num=1
	while [ $prc_num -le $PROCESSOR_NUM ]
	do
		grep "PE "$prc_num ${arr_logfile[$prc_num]} | tail -n 1
		if [ "$kind" = "$SCRATCH" ]
		then
			success=`grep "All" ${arr_logfile[$prc_num]} | wc -l`
			success_num=`expr $success_num + $success`
		fi
		sed -i "s/\r\r\n/\r\n/g" ${arr_logfile[$prc_num]}
		prc_num=`expr $prc_num + 1`
	done
	rm -f ./pe*.sh
}

# skyeye_conf����
get_skyeye_conf()
{
	skyeye_conf_path="$TTSP_DIR/$SKYEYE_CONF_PATH"
	if [ $PROCESSOR_NUM -gt 1 ]
	then
		prc_num=1
		while [ $prc_num -le $PROCESSOR_NUM ]
		do
			arr_skyeye_conf[$prc_num]=${skyeye_conf_path}/skyeye_pe${prc_num}.conf
			prc_num=`expr $prc_num + 1`
		done
	else
		arr_skyeye_conf[0]=${skyeye_conf_path}/skyeye_single.conf
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
	arr_logfile[0]=offset
	prc_num=1
	while [ $prc_num -le $PROCESSOR_NUM ]
	do
		arr_logfile[$prc_num]=`echo "skyeye_"$LOGTIME"_"$prc_num".log"`
		prc_num=`expr $prc_num + 1`
	done
}

# ���ե���������
create_log_file()
{
	prc_num=1
	while [ $prc_num -le $PROCESSOR_NUM ]
	do
		echo $SINGLE_LINE >> ${arr_logfile[$prc_num]}
		echo $dir_name >> ${arr_logfile[$prc_num]}
		echo $SINGLE_LINE >> ${arr_logfile[$prc_num]}
		prc_num=`expr $prc_num + 1`
	done
}

# �ץ��å�1����ư�������ˡ�¾�Υץ��å�����ư����ޤ��Ե�
wait_skyeye()
{
	chk=0
	while [ $chk -ne $1 ]
	do
		chk=`ps ax | grep skyeye | wc -l`
		sleep 1
	done
}

# �ץ�����λ
kill_proc()
{
	pid=`ps ax | grep $1 | awk -F ' ' '{print $1}'`
	for id in ${pid[@]}
	do
		kill -9 $id
	done
}

# ������å������ɥƥ��Ȥη�̽���
output_scr_test_result()
{
	header_single "$TEST_RESULT"
	echo "$NUM_OF_TEST: "$test_num
	echo "$NUM_OF_ALL_PASS: "$success_num
}
