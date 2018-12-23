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
#  $Id: common.sh 2 2012-05-09 02:23:52Z nces-shigihara $
# 

##### TTSP���ѿ���� #####

# �ե����̾
MNF_API_TESRY="MANIFEST_AUTO_CODE"
MNF_API_SCR="MANIFEST_SCRATCH_CODE"
MNF_API_ERR="MANIFEST_CONFIG_ERROR"
KERNEL_LIB="kernel_lib"
OBJECT_DIR="obj"
API_TEST_ROOT="api_test"
AUTO_CODE_DIR_NAME="auto_code"
SCRATCH_CODE_DIR_NAME="scratch_code"
CONFIG_ERROR_DIR_NAME="config_error"
SPECIFIED_YAML_DIR_NAME="specified_tesry"
CHECK_LIBRARY_ROOT="check_library"
EXCEPTION_DIR_NAME="exception"
INTERRUPT_DIR_NAME="interrupt"
TIMER_DIR_NAME="timer"
SIL_TEST_ROOT="sil_test"

# ��˥塼����
DOUBLE_LINE=======================================================================
SINGLE_LINE=----------------------------------------------------------------------

MAIN_MENU="TTSP main menu"
BACK_TO_MAIN_MENU="Return to main menu"
EXIT_TOOL="Quit"
INPUT_NO="Please input menu no:"
INPUT_DIV_NUM="Please input divide number:"
INPUT_YAML="Please input specified TESRY (absolute path / file or folder):"
INPUT_SPEC_DIR="Please input folder no: auto_code_"

# API�ƥ���
API_TEST_MENU="API Tests"

AUTO_CODE="Auto-Code Test"
SCRATCH="Scratch-Code Test"
CONF_ERR="Configuration Error Test"
SPECIFIED_YAML="Test for specified TESRY"

GENE_ALL_MNF="Generate a MANIFEST file for All TESRYs"
GENE_FNC_MNF="Generate a MANIFEST file for each functions"
GENE_DIV_MNF="Generate a MANIFEST file divided by specified number"
GENE_SCR_MNF="Generate a MANIFEST file for scratch code test"
GENE_ERR_MNF="Generate a MANIFEST file for configuration error test"
API_ALL=api_all
API_FNC=api_fnc
API_DIV=api_div

EXEC_5_8="Build all program files (No.5-8)"
EXEC_3_5="Build all program files (No.3-5)"
EXEC_3_4="Build and check all program files (No.3-4)"
EXEC_2_4="Build a program file (No.2-4)"
MNF_MAKE_DIR="Make MANIFEST folders"
EXEC_TTG="Execute TTG"
MNF_MAKE_DEPEND="\"make depend\" for each MANIFEST folders"
MNF_MAKE_BUILD="\"make\" for each MANIFEST folders"
MNF_MAKE_CLEAN="\"make clean\" for each MANIFEST folders"
MNF_MAKE_REALCLEAN="\"make realclean\" for each MANIFEST folders"
OPERATE_SPEC_DIR="Operate a specified MANIFEST folder"
SPC_MAKE_DIR="Make $SPECIFIED_YAML_DIR_NAME folder"
SPC_MAKE_DEPEND="\"make depend\" for $SPECIFIED_YAML_DIR_NAME folder"
SPC_MAKE_BUILD="\"make\" for $SPECIFIED_YAML_DIR_NAME folder"
SPC_MAKE_CLEAN="\"make clean\" for $SPECIFIED_YAML_DIR_NAME folder"
SPC_MAKE_REALCLEAN="\"make realclean\" for $SPECIFIED_YAML_DIR_NAME folder"
RUN_EXEC_MODULE="Run executable module (Target Dependent)"
CHK_CFG_ERR="Check configuration error for each MANIFEST folders"
EXEC_TTG_TO_MAKE="Execute TTG and build specified TESRY (No.2-5)"
SPCDIR_MAKE_DEPEND="\"make depend\""
SPCDIR_MAKE_BUILD="\"make\""
SPCDIR_MAKE_CLEAN="\"make clean\""
SPCDIR_MAKE_REALCLEAN="\"make realclean\""

# SIL�ƥ���
SIL_TEST_MENU="SIL Tests"

SIL_ALL_BUILD="Build the program (No.2-4)"
SIL_MAKE_DIR="Make folder for SIL test"
SIL_MAKE_DEPEND="\"make depend\" for SIL test"
SIL_MAKE_BUILD="\"make\" for SIL test"
SIL_MAKE_CLEAN="\"make clean\" for SIL test"
SIL_MAKE_REALCLEAN="\"make realclean\" for SIL test"

# �����å��饤�֥��
CHECK_LIBRARY_MENU="Check the Functions for Target Dependent"

CHECK_ALL_FUNC_2_4="Check all function (No.2-4)"
CHECK_ALL_FUNC="Check all function"
CHECK_EXC="Check exception"
CHECK_INT="Check interrupt"
CHECK_TIM="Check timer"

CHECK_ALL_FUNC_ALL_BUILD="Build the all function (No.2-4)"
CHECK_ALL_FUNC_MKDIR="Make folders for each function"
CHECK_ALL_FUNC_DEPEND="\"make depend\" for each function folders"
CHECK_ALL_FUNC_BUILD="\"make\" for each function folders"
CHECK_ALL_FUNC_CLEAN="\"make clean\" for each function folders"
CHECK_ALL_FUNC_REALCLEAN="\"make realclean\" for each function folders"
CHECK_EXC_ALL_BUILD="Build the exception (No.2-4)"
CHECK_EXC_MKDIR="Make $EXCEPTION_DIR_NAME folder"
CHECK_EXC_DEPEND="\"make depend\" for $EXCEPTION_DIR_NAME folder"
CHECK_EXC_BUILD="\"make\" for $EXCEPTION_DIR_NAME folder"
CHECK_EXC_CLEAN="\"make clean\" for $EXCEPTION_DIR_NAME folder"
CHECK_EXC_REALCLEAN="\"make realclean\" for $EXCEPTION_DIR_NAME folder"
CHECK_INT_ALL_BUILD="Build the interrupt (No.2-4)"
CHECK_INT_MKDIR="Make $INTERRUPT_DIR_NAME folder"
CHECK_INT_DEPEND="\"make depend\" for $INTERRUPT_DIR_NAME folder"
CHECK_INT_BUILD="\"make\" for $INTERRUPT_DIR_NAME folder"
CHECK_INT_CLEAN="\"make clean\" for $INTERRUPT_DIR_NAME folder"
CHECK_INT_REALCLEAN="\"make realclean\" for $INTERRUPT_DIR_NAME folder"
CHECK_TIM_ALL_BUILD="Build the timer (No.2-4)"
CHECK_TIM_MKDIR="Make $TIMER_DIR_NAME folder"
CHECK_TIM_DEPEND="\"make depend\" for $TIMER_DIR_NAME folder"
CHECK_TIM_BUILD="\"make\" for $TIMER_DIR_NAME folder"
CHECK_TIM_CLEAN="\"make clean\" for $TIMER_DIR_NAME folder"
CHECK_TIM_REALCLEAN="\"make realclean\" for $TIMER_DIR_NAME folder"


# �����ͥ�饤�֥��
KERNEL_LIBRARY_MENU="Kernel Library"

L_ALL="Build the kernel library (No.2-4)"
L_MKDIR="Make kernel library folder"
L_DEPEND="\"make depend\" for $KERNEL_LIB folder"
L_BUILD="\"make\" for $KERNEL_LIB folder"
L_CLEAN="\"make clean\" for $KERNEL_LIB folder"
L_REALCLEAN="\"make realclean\" for $KERNEL_LIB folder"
L_APPLI_NAME=sample1

# �����¹Ի��Υ�å�����
GENERATE=Generate
PRE_MAKE_DIRECTORY=make
POST_MAKE_DIRECTORY=folder
TTG_IN="Execute TTG in"
MAKE_DEPEND="make depend in"
MAKE_BUILD="make in"
MAKE_CLEAN="make clean in"
MAKE_REALCLEAN="make realclean in"
RUN_EXEC="Run executable module in"
TEST_OK=": Test OK"
TEST_NG=": Test Error!! -> Check"
TEST_RESULT="Test result"
NUM_OF_TEST="Test number"
NUM_OF_OK="Test OK"
NUM_OF_ALL_PASS="\"All check points passed\" number"
NOT_SUPPORT="Not supported"

# ���顼��å�����
ERR_PROFILE_INVALID="PROFILE_NAME is invalid"
ERR_USE_KER_LIB_INVALID="USE_KERNEL_LIB is invalid"
ERR_INVALID_NO="is invalid input"
ERR_NO_FILE="file is not exist"
ERR_NO_DIR="folder is not exist"
ERR_EMP_FILE="file is empty"
ERR_TTG_FAIL="TTG failed in"
ERR_DEPEND_FAIL="make depend failed in"
ERR_CREAT_MAKEFILE_FAIL="Create Makefile failed"
ERR_PATH_FAIL="specified TESRY's path is wrong"

# ����¾���
RULE_DEPEND=depend
RULE_BUILD=build
RULE_CLEAN=clean
RULE_REALCLEAM=realclean
WARNING=warning
VARI_PRC_NUM=prc_num
VARI_TIMER_ARCH=timer_arch
VARI_FUNC_TIM=func_time
VARI_FUNC_INT=func_interrupt
VARI_FUNC_EXC=func_exception
VARI_IRC_ARCH=irc_arch
APPLI_NAME_FOR_SCR=out
AT91SKYEYE=at91skyeye_gcc

ERR_CODE=err_code.txt
VARIATION_TXT=variation.txt
RESULT_CONF_ERR=result_config_error.log
RESULT_TTG=result_ttg.log
RESULT_MAKE_DEPEND=result_make_depend.log
RESULT_MAKE=result_make.log

# ��ǽ�̥ե����̾����
TEST_TARGET="\
task_manage \
task_sync \
task_except \
dataqueue \
eventflag \
mailbox \
mempfix \
pridataq \
semaphore \
cyclic \
alarm \
sys_manage \
interrupt \
exception \
task_refer \
time_manage \
spin_lock \
staticAPI"

# realpath���ޥ�ɤ�̵ͭ�����
which realpath &> /dev/null
if [ $? == 0 ]
then
	IS_REALPATH=true
else
	IS_REALPATH=false
fi

##### �ؿ� #####

# �¹Ի��Υإå�������(�����)
# ���� $1 : �إå�����ɽ���������������
header_double()
{
	echo ""
	echo $DOUBLE_LINE
	echo $1
	echo $DOUBLE_LINE
}

# �¹Ի��Υإå�������(ñ��)
# ���� $1 : �إå�����ɽ���������������
header_single()
{
	echo ""
	echo $SINGLE_LINE
	echo $1
	echo $SINGLE_LINE
}

# �ե�����¸�ߥ����å�
check_file()
{
	chk_flg=0

	for file_path in ${check_file_name[@]}
	do
		if [ ! -f $file_path ]
		then
			echo "${file_path##*/} $ERR_NO_FILE"
			chk_flg=1
		fi
	done
	return $chk_flg
}

# �ե����¸�ߥ����å�
check_dir()
{
	chk_flg=0
	for dir_path in ${check_dir_name[@]}
	do
		dir_path=`echo $dir_path | sed -e "s/\/$//"`
		if [ ! -d $dir_path ]
		then
			echo "${dir_path##*/} $ERR_NO_DIR"
			chk_flg=1
		fi
	done
	return $chk_flg
}

# �ե����뤬���ե����뤫������å�
check_empty_file()
{
	chk_flg=0
	all_step=0

	all_step=`cat $check_file_name | wc -l`
	if [ $all_step = 0 ]
	then
		echo "${check_file_name##*/} $ERR_EMP_FILE"
		chk_flg=1
	fi
	return $chk_flg
}

# �ե�����ǽ��Ԥβ���̵ͭ�Υ����å�
# ���Ԥ��ʤ���С����Ԥ�����
check_last_break()
{
	all_step=0

	for file_path in ${check_file_name[@]};
	do
		last1=`cat $file_path | tail -1`
		all_step=`wc -l $file_path | awk -F ' ' '{print $1}'`
		last2=`sed -n "$all_step"p $file_path`
		if [ ! "$last1" = "$last2" ]
		then
			echo "" >> $file_path
		fi
	done

}

# make���ץ�����"-f"�����ꤵ��Ƥ��뤫�Υ����å�
# ���ꤵ��Ƥ���С�MAKEFILE�ѿ��Ȥ������
check_makefile()
{
	makeopt=($MAKE_OPT)

    num=0
	while [ "${makeopt[$num]}" != "" ]
	do
		if [ "${makeopt[num]}" = "-f" ]
		then
			MAKE_FILE_NAME=${makeopt[num+1]}
			num=`expr $num + 2`
			return 
		else
			num=`expr $num + 1`
		fi
	done
	MAKE_FILE_NAME="Makefile"
}

# �ޥ˥ե����ȥե��������#�ǥ����ȥ����Ȥ����ƥ��ȥ����������
# ����������Υƥ��ȥ����������ϡ�����Ȥ����ѿ�test_case_list�˳�Ǽ
exclusion_comment_out()
{
	test_case_list=`grep -v "^#.*" $check_file_name | xargs`
}

# ���Хѥ�����
get_realpath()
{
	if [ $IS_REALPATH == "true" ]
	then
		rpath=`realpath $1`
		echo $rpath
	else
		echo "$PWD/$1"
	fi
}

# �Хꥨ���������ͤ����
get_variation_value()
{
	variation_value=`grep $variation_name $dir_path/$VARIATION_TXT | awk -F ':' '{print $2}'`
}

# �ϥ�ɥ����ǥ��󥰥ƥ��ȥץ����ΥХꥨ�������Ƚ��
# ������å������ɥƥ��ȡ�����ե�����졼����󥨥顼�ƥ��Ȥǻ���
variation_check()
{
	if [ ! -f $dir_path/$VARIATION_TXT ]
	then
		return
	fi
	# �ץ��å����Υ����å�
	variation_name=$VARI_PRC_NUM
	get_variation_value
	if [ $variation_value ]
	then
		if [ $variation_value -gt $PROCESSOR_NUM ]
		then
			vari_flg=1
			return
		fi
	fi
	# �����ޥ������ƥ�����Υ����å�
	variation_name=$VARI_TIMER_ARCH
	get_variation_value
	if [ $variation_value ]
	then
		if [ $variation_value != $TIMER_ARCH ]
		then
			vari_flg=1
			return
		fi
	fi
	# �����ƥ��������ؿ���̵ͭ�����å�
	variation_name=$VARI_FUNC_TIM
	get_variation_value
	if [ $variation_value ]
	then
		if [ $variation_value = "true" -a $FUNC_TIME = "false" ]
		then
			vari_flg=1
			return
		fi
	fi
	# �����ȯ���ؿ���̵ͭ�����å�
	variation_name=$VARI_FUNC_INT
	get_variation_value
	if [ $variation_value ]
	then
		if [ $variation_value = "true" -a $FUNC_INTERRUPT = "false" ]
		then
			vari_flg=1
			return
		fi
	fi
	# CPU�㳰ȯ���ؿ���̵ͭ�����å�
	variation_name=$VARI_FUNC_EXC
	get_variation_value
	if [ $variation_value ]
	then
		if [ $variation_value = "true" -a $FUNC_EXCEPTION = "false" ]
		then
			vari_flg=1
			return
		fi
	fi
	# IRC�������ƥ�����Υ����å�
	variation_name=$VARI_IRC_ARCH
	get_variation_value
	if [ $variation_value ]
	then
		if [ $variation_value != $IRC_ARCH ]
		then
			vari_flg=1
			return
		fi
	fi
}

# ������å��ץ����Υե�����̾��APPLI_NAME���ѹ�
rename_scratch_program()
{
	if [ "$APPLI_NAME_FOR_SCR" != "$APPLI_NAME" ]
	then
		flg=`find ./ -name "$APPLI_NAME.*"` #> /dev/null`
		if [ ! "$flg" ]
		then
			mv $APPLI_NAME_FOR_SCR.c $APPLI_NAME.c
			mv $APPLI_NAME_FOR_SCR.h $APPLI_NAME.h
			mv $APPLI_NAME_FOR_SCR.cfg $APPLI_NAME.cfg
			sed -i -e "s/#include\ \"$APPLI_NAME_FOR_SCR.h\"/#include\ \"$APPLI_NAME.h\"/" ./$APPLI_NAME.*
		fi
	fi
}
# Makefile���Ѥ��ƹԤ�����(make depend, make, make clean, 
# make realclean)�μ¹�(�ޥ˥ե����ȥե����뤬�ʤ����)
make_for_no_manifest()
{
	check_dir_name=$dir_name
	check_dir
	if [ $? -eq 0 ]
	then
		cd $dir_name
		substitution_file_name
		check_file
		if [ $? -eq 1 ]
		then
			cd $TTSP_DIR
			return
		fi
		case $rule in
			$RULE_DEPEND)
			 make depend $MAKE_OPT KERNEL_COBJS="$KERNEL_COBJS_COMMON $KERNEL_COBJS_TARGET" 2>&1 | tee $RESULT_MAKE_DEPEND
			 ;;
			$RULE_BUILD)
			 make $MAKE_OPT KERNEL_COBJS="$KERNEL_COBJS_COMMON $KERNEL_COBJS_TARGET" 2>&1 | tee $RESULT_MAKE
			 ;;
			$RULE_CLEAN)
			 make clean $MAKE_OPT KERNEL_COBJS="$KERNEL_COBJS_COMMON $KERNEL_COBJS_TARGET"
			 ;;
			$RULE_REALCLEAM)
			 make realclean $MAKE_OPT KERNEL_COBJS="$KERNEL_COBJS_COMMON $KERNEL_COBJS_TARGET"
			 ;;
		esac
		cd $TTSP_DIR
	fi
}

# Makefile���Ѥ��ƹԤ�����(make depend, make, make clean, 
# make realclean)�μ¹�
make_for_common()
{
	case $rule in
		$RULE_DEPEND)
		 header_single "$MAKE_DEPEND $dir_name"
		 ( make depend $MAKE_OPT KERNEL_COBJS="$KERNEL_COBJS_COMMON $KERNEL_COBJS_TARGET" 2>&1; echo $? >status_file ) | tee $RESULT_MAKE_DEPEND
		 status=`cat status_file`
		 rm -rf status_file
		 ;;
		$RULE_BUILD)
		 header_single "$MAKE_BUILD $dir_name"
		 make $MAKE_OPT KERNEL_COBJS="$KERNEL_COBJS_COMMON $KERNEL_COBJS_TARGET" 2>&1 | tee $RESULT_MAKE
		 ;;
		$RULE_CLEAN)
		 header_single "$MAKE_CLEAN $dir_name"
		 make clean $MAKE_OPT KERNEL_COBJS="$KERNEL_COBJS_COMMON $KERNEL_COBJS_TARGET"
		 ;;
		$RULE_REALCLEAM)
		 header_single "$MAKE_REALCLEAN $dir_name"
		 make realclean $MAKE_OPT KERNEL_COBJS="$KERNEL_COBJS_COMMON $KERNEL_COBJS_TARGET"
		 ;;
	esac
	return $status
}

# Makefile����Ѥ���ݤ�ɬ�פʥե���������
substitution_file_name()
{
	case $rule in
		$RULE_DEPEND)
		 check_file_name="$appli_name.c \
	                      $appli_name.h \
	                      $appli_name.cfg \
	                      $MAKE_FILE_NAME"
		 ;;
		$RULE_BUILD)
		 check_file_name="$appli_name.c \
	                      $appli_name.h \
	                      $appli_name.cfg \
	                      $MAKE_FILE_NAME"
		 ;;
		$RULE_CLEAN)
		 check_file_name="$MAKE_FILE_NAME"
		 ;;
		$RULE_REALCLEAM)
		 check_file_name="$MAKE_FILE_NAME"
		 ;;
	esac
}

# TESRY���Ѥ����ƥ��Ȥ�Makefile���Ѥ��ƹԤ�����(make depend, make, 
# make clean, make realclean)�μ¹�
make_for_tesry()
{
	check_dir_name=$OBJECT_DIR/$root_dir
	check_dir
	if [ $? -eq 1 ]
	then
		return
	fi
	cd $OBJECT_DIR/$root_dir
	list_num=`ls -l | grep $pre_dir_name\_ | wc -l`
	if [ $list_num -eq 0 ]
	then
		echo $pre_dir_name'_* '$ERR_NO_DIR
	else
		cnt=0
		while [ $list_num -gt 0 ]
		do
			cnt=`expr $cnt + 1`
			dir_name=$pre_dir_name\_$cnt
			if [ ! -d $dir_name ]
			then
				continue
			fi
			cd $dir_name
			appli_name=$APPLI_NAME
			substitution_file_name
			check_file
			if [ $? -ne 1 ]
			then
				make_for_common
			fi
			cd ../
			list_num=`expr $list_num - 1`
		done
	fi
	cd $TTSP_DIR
}

# ������å��ƥ��Ȥ�Makefile���Ѥ��ƹԤ�����(make depend, make, 
# make clean, make realclean)�μ¹�
make_for_scratch()
{
	check_file_name=$OBJECT_DIR/$root_dir/$manifest_name
	check_file
	if [ $? -eq 1 ]
	then
		return
	fi
	check_last_break
	exclusion_comment_out

	check_dir_name=$OBJECT_DIR/$root_dir/$sub_dir
	check_dir
	if [ $? -eq 1 ]
	then
		return
	fi
	cd $OBJECT_DIR/$root_dir/$sub_dir
	for dir in ${test_case_list[@]}
	do
		dir_name=${dir##*/}
		check_dir_name=$dir_name
		check_dir
		if [ $? -eq 1 ]
		then
			continue
		fi
		cd $dir_name
		appli_name=$APPLI_NAME
		substitution_file_name
		check_file
		if [ $? -ne 1 ]
		then
			make_for_common
		fi
		cd ../
	done
	cd $TTSP_DIR
}

# ����ե�����졼����󥨥顼�ƥ��Ȥη�̽���
output_config_err_test_result()
{
	header_single "$TEST_RESULT"
	echo "$NUM_OF_TEST: "$test_num
	echo "$NUM_OF_OK: "$success_num
}

# �¹ԥ⥸�塼���¹Ԥ���ե�����ؤΰ�ư(�����ȥ����ɥƥ�����)
execute_module_for_tesry()
{
	check_dir_name=$OBJECT_DIR/$root_dir
	check_dir
	if [ $? -eq 1 ]
	then
		return
	fi

	cd $OBJECT_DIR/$root_dir
	list_num=`ls -l | grep $pre_dir_name\_ | wc -l`
	if [ $list_num -eq 0 ]
	then
		echo $pre_dir_name'_* '$ERR_NO_DIR
	else
		cnt=0
		while [ $list_num -gt 0 ]
		do
			cnt=`expr $cnt + 1`
			dir_name=$pre_dir_name\_$cnt
			if [ ! -d $dir_name ]
			then
				continue
			fi
			header_single "$RUN_EXEC $dir_name"
			cd $dir_name
			simulation
			cd ../
			list_num=`expr $list_num - 1`
		done
	fi
	cd $TTSP_DIR
}

# �¹ԥ⥸�塼���¹Ԥ���ե�����ؤΰ�ư(������å������ɥƥ�����)
execute_module_for_scratch()
{
	success_num=0

	check_file_name=$OBJECT_DIR/$root_dir/$manifest_name
	check_file
	if [ $? -eq 1 ]
	then
		return
	fi
	check_empty_file
	if [ $? -eq 1 ]
	then
		return
	fi
	check_last_break
	exclusion_comment_out

	check_dir_name=$OBJECT_DIR/$root_dir/$sub_dir
	check_dir
	if [ $? -eq 1 ]
	then
		return
	fi

	cd $OBJECT_DIR/$root_dir/$sub_dir
	for dir in ${test_case_list[@]}
	do
		dir_name=${dir##*/}
		header_single "$RUN_EXEC $dir_name"
		cd $dir_name
		simulation
		cd ../
	done
	cd $TTSP_DIR

	# �¹Է��ɽ��(at91skyeye_gcc�ξ��)
	if [ $TARGET_NAME = $AT91SKYEYE ]
	then
		arr=(`echo $test_case_list`)
		test_num="${#arr[@]}"
		output_scr_test_result
	fi
}

# �¹ԥ⥸�塼���¹Ԥ���ե�����ؤΰ�ư
# (�ޥ˥ե����ȥե�������Ѥ��ʤ��ƥ�����)
execute_module_for_no_manifest()
{
	check_dir_name=$OBJECT_DIR/$root_dir/$dir_name
	check_dir
	if [ $? -eq 1 ]
	then
		return
	fi

	cd $OBJECT_DIR/$root_dir/$dir_name
	header_single "$RUN_EXEC $dir_name"
	simulation
	cd $TTSP_DIR
}

execute_module()
{
	if [ $EXC_MODULE != "true" ]
	then
		echo "$NOT_SUPPORT"
	else
		case $kind in
			"$AUTO_CODE")
			 root_dir=$API_TEST_ROOT
			 pre_dir_name=$AUTO_CODE_DIR_NAME
			 execute_module_for_tesry
			 ;;
			"$SCRATCH")
			 root_dir=$API_TEST_ROOT
			 sub_dir=$SCRATCH_CODE_DIR_NAME
			 manifest_name=$MNF_API_SCR
			 execute_module_for_scratch
			 ;;
			"$SPECIFIED_YAML")
			 root_dir=$API_TEST_ROOT
			 dir_name=$SPECIFIED_YAML_DIR_NAME
			 execute_module_for_no_manifest
			 ;;
			"$CHECK_ALL_FUNC")
			 root_dir=$CHECK_LIBRARY_ROOT
			 pre_dir_name="$EXCEPTION_DIR_NAME $INTERRUPT_DIR_NAME $TIMER_DIR_NAME"
			 for dir_name in ${pre_dir_name[@]}
			 do
				execute_module_for_no_manifest
			 done
			 ;;
			"$CHECK_EXC")
			 root_dir=$CHECK_LIBRARY_ROOT
			 dir_name=$EXCEPTION_DIR_NAME
			 execute_module_for_no_manifest
			 ;;
			"$CHECK_INT")
			 root_dir=$CHECK_LIBRARY_ROOT
			 dir_name=$INTERRUPT_DIR_NAME
			 execute_module_for_no_manifest
			 ;;
			"$CHECK_TIM")
			 root_dir=$CHECK_LIBRARY_ROOT
			 dir_name=$TIMER_DIR_NAME
			 execute_module_for_no_manifest
			 ;;
			"$SIL_TEST_MENU")
			 root_dir=""
			 dir_name=$SIL_TEST_ROOT
			 execute_module_for_no_manifest
			 ;;
			"$OPERATE_SPEC_DIR")
			 header_single "$RUN_EXEC $dir_name"
			 simulation
			 ;;
		esac
	fi
}
