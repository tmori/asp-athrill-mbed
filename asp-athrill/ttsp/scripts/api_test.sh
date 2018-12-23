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
#  $Id: api_test.sh 2 2012-05-09 02:23:52Z nces-shigihara $
# 

# API�ƥ��ȥ�˥塼
api_test_main()
{
	if [ $USE_KERNEL_LIB = "true" ]
	then
		check_file_name=$KERNEL_LIB/libkernel.a
		check_file
		if [ $? -eq 1 ]
		then
			return
		fi
	fi
	while true
	do
		cat<<EOS

$DOUBLE_LINE
 $API_TEST_MENU
$DOUBLE_LINE
 1: $AUTO_CODE
 2: $SCRATCH
 3: $CONF_ERR
 4: $SPECIFIED_YAML
 r: $BACK_TO_MAIN_MENU
 q: $EXIT_TOOL
$SINGLE_LINE
EOS
echo -n " $INPUT_NO "
		# �����ɤ߹���
		read key
		# �ɤ߹���������ˤ�ä�ʬ��
		case ${key} in
			1)
			 auto_code
			 ;;
			2)
			 scratch
			 ;;
			3)
			 configuration_error
			 ;;
			4)
			 specified_yaml
			 ;;
			r)
			 go_main_flg=1
			 ;;
			q)
			 exit 0
			 ;;
			*)
			 echo " $key $ERR_INVALID_NO"
			 ;;
		esac
		if [ $go_main_flg -eq 1 ]
		then
			go_main_flg=0
			break
		fi
		
	done
}

# �����ȥ����ɥƥ��ȥ�˥塼
auto_code()
{
	while true
	do
		cat<<EOS

$DOUBLE_LINE
 $API_TEST_MENU ($AUTO_CODE)
$DOUBLE_LINE
 1: $GENE_ALL_MNF
 2: $GENE_FNC_MNF
 3: $GENE_DIV_MNF
 4: $EXEC_5_8
 5: $MNF_MAKE_DIR
 6: $EXEC_TTG
 7: $MNF_MAKE_DEPEND
 8: $MNF_MAKE_BUILD
 9: $MNF_MAKE_CLEAN
 a: $MNF_MAKE_REALCLEAN
 b: $OPERATE_SPEC_DIR
 e: $RUN_EXEC_MODULE
 r: $BACK_TO_MAIN_MENU
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
			 header_double "$GENE_ALL_MNF"
			 kind=$API_ALL
			 root_dir=$API_TEST_ROOT
			 manifest_name=$MNF_API_TESRY
			 make_manifest_for_tesry
			 ;;
			2)
			 header_double "$GENE_FNC_MNF"
			 kind=$API_FNC
			 root_dir=$API_TEST_ROOT
			 manifest_name=$MNF_API_TESRY
			 make_manifest_for_tesry
			 ;;
			3)
			 header_double "$GENE_DIV_MNF"
			 kind=$API_DIV
			 root_dir=$API_TEST_ROOT
			 manifest_name=$MNF_API_TESRY
			 make_manifest_for_tesry
			 ;;
			4)
			 header_double "$EXEC_5_8"
			 root_dir=$API_TEST_ROOT
			 manifest_name=$MNF_API_TESRY
			 pre_dir_name=$AUTO_CODE_DIR_NAME
			 continuous_execute_for_tesry
			 
			 ;;
			5)
			 header_double "$MNF_MAKE_DIR"
			 root_dir=$API_TEST_ROOT
			 manifest_name=$MNF_API_TESRY
			 pre_dir_name=$AUTO_CODE_DIR_NAME
			 make_directory_for_tesry
			 ;;
			6)
			 header_double "$EXEC_TTG"
			 root_dir=$API_TEST_ROOT
			 manifest_name=$MNF_API_TESRY
			 pre_dir_name=$AUTO_CODE_DIR_NAME
			 execute_ttg_for_manifest
			 ;;
			7)
			 header_double "$MNF_MAKE_DEPEND"
			 root_dir=$API_TEST_ROOT
			 pre_dir_name=$AUTO_CODE_DIR_NAME
			 rule=$RULE_DEPEND
			 make_for_tesry
			 ;;
			8)
			 header_double "$MNF_MAKE_BUILD"
			 root_dir=$API_TEST_ROOT
			 pre_dir_name=$AUTO_CODE_DIR_NAME
			 rule=$RULE_BUILD
			 make_for_tesry
			 ;;
			9)
			 header_double "$MNF_MAKE_CLEAN"
			 root_dir=$API_TEST_ROOT
			 pre_dir_name=$AUTO_CODE_DIR_NAME
			 rule=$RULE_CLEAN
			 make_for_tesry
			 ;;
			a)
			 header_double "$MNF_MAKE_REALCLEAN"
			 root_dir=$API_TEST_ROOT
			 pre_dir_name=$AUTO_CODE_DIR_NAME
			 rule=$RULE_REALCLEAM
			 make_for_tesry
			 ;;
			b)
			 root_dir=$API_TEST_ROOT
			 pre_dir_name=$AUTO_CODE_DIR_NAME
			 operate_spec_dir
			 ;;
			e)
			 header_double "$RUN_EXEC_MODULE"
			 kind="$AUTO_CODE"
			 execute_module
			 ;;
			r)
			 go_main_flg=1
			 ;;
			q)
			 exit 0
			 ;;
			*)
			 echo " $key $ERR_INVALID_NO"
			 ;;
		esac
		if [ $go_main_flg -eq 1 ]
		then
			break
		fi
	done
}

# ������å������ɥƥ��ȥ�˥塼
scratch()
{
	while true
	do
		cat<<EOS

$DOUBLE_LINE
 $API_TEST_MENU ($SCRATCH)
$DOUBLE_LINE
 1: $GENE_SCR_MNF
 2: $EXEC_3_5
 3: $MNF_MAKE_DIR
 4: $MNF_MAKE_DEPEND
 5: $MNF_MAKE_BUILD
 6: $MNF_MAKE_CLEAN
 7: $MNF_MAKE_REALCLEAN
 e: $RUN_EXEC_MODULE
 r: $BACK_TO_MAIN_MENU
 q: Quit
$SINGLE_LINE
EOS
echo -n " $INPUT_NO "
		# �����ɤ߹���
		read key
		echo ""
		# �ɤ߹���������ˤ�ä�ʬ��
		case ${key} in
			1)
			 header_double "$GENE_SCR_MNF"
			 root_dir=$API_TEST_ROOT
			 manifest_name=$MNF_API_SCR
			 kind="$SCRATCH"
			 make_manifest_for_scr_and_err
			 ;;
			2)
			 header_double "$EXEC_3_5"
			 root_dir=$API_TEST_ROOT
			 sub_dir=$SCRATCH_CODE_DIR_NAME
			 manifest_name=$MNF_API_SCR
			 kind="$SCRATCH"
			 continuous_execute_for_scr_and_err
			 ;;
			3)
			 header_double "$MNF_MAKE_DIR"
			 root_dir=$API_TEST_ROOT
			 sub_dir=$SCRATCH_CODE_DIR_NAME
			 manifest_name=$MNF_API_SCR
			 kind="$SCRATCH"
			 make_directory_for_scr_and_err
			 ;;
			4)
			 header_double "$MNF_MAKE_DEPEND"
			 root_dir=$API_TEST_ROOT
			 sub_dir=$SCRATCH_CODE_DIR_NAME
			 manifest_name=$MNF_API_SCR
			 rule=$RULE_DEPEND
			 make_for_scratch
			 ;;
			5)
			 header_double "$MNF_MAKE_BUILD"
			 root_dir=$API_TEST_ROOT
			 sub_dir=$SCRATCH_CODE_DIR_NAME
			 manifest_name=$MNF_API_SCR
			 rule=$RULE_BUILD
			 make_for_scratch
			 ;;
			6)
			 header_double "$MNF_MAKE_CLEAN"
			 root_dir=$API_TEST_ROOT
			 sub_dir=$SCRATCH_CODE_DIR_NAME
			 manifest_name=$MNF_API_SCR
			 rule=$RULE_CLEAN
			 make_for_scratch
			 ;;
			7)
			 header_double "$MNF_MAKE_REALCLEAN"
			 root_dir=$API_TEST_ROOT
			 sub_dir=$SCRATCH_CODE_DIR_NAME
			 manifest_name=$MNF_API_SCR
			 rule=$RULE_REALCLEAM
			 make_for_scratch
			 ;;
			e)
			 header_double "$RUN_EXEC_MODULE"
			 kind="$SCRATCH"
			 execute_module
			 ;;
			r)
			 go_main_flg=1
			 ;;
			q)
			 exit 0
			 ;;
			*)
			 echo " $key $ERR_INVALID_NO"
			 ;;
		esac
		if [ $go_main_flg -eq 1 ]
		then
			break
		fi
	done
}

# ����ե�����졼����󥨥顼�ƥ��ȥ�˥塼
configuration_error()
{
	while true
	do
		cat<<EOS

$DOUBLE_LINE
 $API_TEST_MENU ($CONF_ERR)
$DOUBLE_LINE
 1: $GENE_ERR_MNF
 2: $EXEC_3_4
 3: $MNF_MAKE_DIR
 4: $CHK_CFG_ERR
 r: $BACK_TO_MAIN_MENU
 q: Quit
$SINGLE_LINE
EOS
echo -n " $INPUT_NO "
		# �����ɤ߹���
		read key
		echo ""
		# �ɤ߹���������ˤ�ä�ʬ��
		case ${key} in
			1)
			 header_double "$GENE_ERR_MNF"
			 root_dir=$API_TEST_ROOT
			 manifest_name=$MNF_API_ERR
			 kind="$CONF_ERR"
			 make_manifest_for_scr_and_err
			 ;;
			2)
			 header_double "$EXEC_3_4"
			 root_dir=$API_TEST_ROOT
			 sub_dir=$CONFIG_ERROR_DIR_NAME
			 manifest_name=$MNF_API_ERR
			 kind="$CONF_ERR"
			 continuous_execute_for_scr_and_err
			 ;;
			3)
			 header_double "$MNF_MAKE_DIR"
			 root_dir=$API_TEST_ROOT
			 sub_dir=$CONFIG_ERROR_DIR_NAME
			 manifest_name=$MNF_API_ERR
			 kind="$CONF_ERR"
			 make_directory_for_scr_and_err
			 ;;
			4)
			 header_double "$CHK_CFG_ERR"
			 root_dir=$API_TEST_ROOT
			 sub_dir=$CONFIG_ERROR_DIR_NAME
			 manifest_name=$MNF_API_ERR
			 check_configuration_error
			 ;;
			r)
			 go_main_flg=1
			 ;;
			q)
			 exit 0
			 ;;
			*)
			 echo " $key $ERR_INVALID_NO"
			 ;;
		esac
		if [ $go_main_flg -eq 1 ]
		then
			break
		fi
	done
}

# ����YAML�Υƥ��ȥ�˥塼
specified_yaml()
{
	while true
	do
		cat<<EOS

$DOUBLE_LINE
 $API_TEST_MENU ($SPECIFIED_YAML)
$DOUBLE_LINE
 1: $EXEC_TTG_TO_MAKE
 2: $SPC_MAKE_DIR
 3: $EXEC_TTG
 4: $SPC_MAKE_DEPEND
 5: $SPC_MAKE_BUILD
 6: $SPC_MAKE_CLEAN
 7: $SPC_MAKE_REALCLEAN
 e: $RUN_EXEC_MODULE
 r: $BACK_TO_MAIN_MENU
 q: Quit
$SINGLE_LINE
EOS
echo -n " $INPUT_NO "
		# �����ɤ߹���
		read key
		echo ""
		# �ɤ߹���������ˤ�ä�ʬ��
		case ${key} in
			1)
			 header_double "$EXEC_TTG_TO_MAKE"
			 root_dir=$API_TEST_ROOT
			 dir_name=$SPECIFIED_YAML_DIR_NAME
			 continuous_execute_for_specified_yaml
			 ;;
			2)
			 header_double "$SPC_MAKE_DIR"
			 rm -rf $OBJECT_DIR/$API_TEST_ROOT/$SPECIFIED_YAML_DIR_NAME
			 echo "$PRE_MAKE_DIRECTORY $SPECIFIED_YAML_DIR_NAME $POST_MAKE_DIRECTORY"
			 mkdir -p $OBJECT_DIR/$API_TEST_ROOT/$SPECIFIED_YAML_DIR_NAME
			 cd $OBJECT_DIR/$API_TEST_ROOT/$SPECIFIED_YAML_DIR_NAME
			 perl ../../../../configure $CONFIG_TEST_PROGRAM "$INCLUDE_DIR" &> /dev/null
			 cd $TTSP_DIR
			 ;;
			3)
			 header_double "$EXEC_TTG"
			 root_dir=$API_TEST_ROOT
			 dir_name=$SPECIFIED_YAML_DIR_NAME
			 execute_ttg_for_no_manifest
			 ;;
			4)
			 header_double "$SPC_MAKE_DEPEND"
			 rule=$RULE_DEPEND
			 dir_name=$OBJECT_DIR/$API_TEST_ROOT/$SPECIFIED_YAML_DIR_NAME
			 appli_name=$APPLI_NAME
			 make_for_no_manifest
			 ;;
			5)
			 header_double "$SPC_MAKE_BUILD"
			 rule=$RULE_BUILD
			 dir_name=$OBJECT_DIR/$API_TEST_ROOT/$SPECIFIED_YAML_DIR_NAME
			 appli_name=$APPLI_NAME
			 make_for_no_manifest
			 ;;
			6)
			 header_double "$SPC_MAKE_CLEAN"
			 rule=$RULE_CLEAN
			 dir_name=$OBJECT_DIR/$API_TEST_ROOT/$SPECIFIED_YAML_DIR_NAME
			 make_for_no_manifest
			 ;;
			7)
			 header_double "$SPC_MAKE_REALCLEAN"
			 rule=$RULE_REALCLEAM
			 dir_name=$OBJECT_DIR/$API_TEST_ROOT/$SPECIFIED_YAML_DIR_NAME
			 make_for_no_manifest
			 ;;
			e)
			 header_double "$RUN_EXEC_MODULE"
			 kind="$SPECIFIED_YAML"
			 execute_module
			 ;;
			r)
			 go_main_flg=1
			 ;;
			q)
			 exit 0
			 ;;
			*)
			 echo " $key $ERR_INVALID_NO"
			 ;;
		esac
		if [ $go_main_flg -eq 1 ]
		then
			break
		fi
	done
}

# ���̤Υޥ˥ե����ȥե�������Ф������(�����ȥ����ɥƥ���)
operate_spec_dir()
{
	check_dir_name=$OBJECT_DIR/$root_dir
	check_dir
	if [ $? -eq 1 ]
	then
		return
	fi

	echo $SINGLE_LINE
	cd $OBJECT_DIR/$root_dir
	list_num=`ls -l | grep $pre_dir_name\_ | wc -l`
	if [ $list_num -eq 0 ]
	then
		echo $pre_dir_name'_* '$ERR_NO_DIR
		return
	fi

	ls -F |grep $pre_dir_name | awk -F '_' '{print $3 $1"_"$2"_"$3}' | sort -n | awk -F '/' '{print $2}'
	echo $SINGLE_LINE
	while true
	do
		echo -n " $INPUT_SPEC_DIR"
		# �����ɤ߹���
		read cnt
		dir_name="$pre_dir_name"_"$cnt"
		if [ -d $dir_name ]
		then
			cd $dir_name
			break
		else
			echo "$dir_name $ERR_NO_DIR"
			echo ""
		fi
	done
	while true
	do
		cat<<EOS

$DOUBLE_LINE
 $OPERATE_SPEC_DIR ($AUTO_CODE) [$dir_name]
$DOUBLE_LINE
 1: $EXEC_2_4
 2: $EXEC_TTG
 3: $SPCDIR_MAKE_DEPEND
 4: $SPCDIR_MAKE_BUILD
 5: $SPCDIR_MAKE_CLEAN
 6: $SPCDIR_MAKE_REALCLEAN
 e: $RUN_EXEC_MODULE
 r: $BACK_TO_MAIN_MENU
 q: $EXIT_TOOL
$SINGLE_LINE
EOS
echo -n " $INPUT_NO "
		# �����ɤ߹���
		read key
		# �ɤ߹���������ˤ�ä�ʬ��
		case ${key} in
			1)
			 header_double "$EXEC_2_4"
			 continuous_execute_for_operate_directory
			 ;;
			2)
			 header_double "$EXEC_TTG"
			 execute_ttg_for_operate_directory
			 ;;
			3)
			 header_double "$SPCDIR_MAKE_DEPEND"
			 rule=$RULE_DEPEND
			 make_for_operate_directory
			 ;;
			4)
			 header_double "$SPCDIR_MAKE_BUILD"
			 rule=$RULE_BUILD
			 make_for_operate_directory
			 ;;
			5)
			 header_double "$SPCDIR_MAKE_CLEAN"
			 rule=$RULE_CLEAN
			 make_for_operate_directory
			 ;;
			6)
			 header_double "$SPCDIR_MAKE_REALCLEAN"
			 rule=$RULE_REALCLEAM
			 make_for_operate_directory
			 ;;
			e)
			 header_double "$RUN_EXEC_MODULE"
			 kind="$OPERATE_SPEC_DIR"
			 execute_module
			 ;;
			r)
			 cd $TTSP_DIR
			 go_main_flg=1
			 ;;
			q)
			 exit 0
			 ;;
			*)
			 echo " $key $ERR_INVALID_NO"
			 ;;
		esac
		if [ $go_main_flg -eq 1 ]
		then
			break
		fi
		
	done
}

# TESRY���Ѥ����ƥ��ȤΥޥ˥ե����Ⱥ���
make_manifest_for_tesry()
{
	flg=0

	mkdir -p $OBJECT_DIR/$root_dir
	cd $OBJECT_DIR/$root_dir
	rm -f temp_aut
	rm -f $manifest_name

	for dir in ${API_TEST_DIR[@]}
	do
		check_dir_name=../../$dir
		check_dir
		if [ $? -ne 1 ]
		then
			api_test_dir=`get_realpath ../../$dir`
			find $api_test_dir/ -name "*.yaml" >> temp_aut
			flg=1
		fi
	done
	if [ $flg = 1 ]
	then
		sed -i -e "/\/\.svn/d" temp_aut # omit svn�ե�����
		case $kind in
			$API_ALL)
			 cat temp_aut | tee $manifest_name
			 ;;
			$API_FNC)
			 for function in ${TEST_TARGET[@]}
			 do
				grep $function temp_aut | tee -a $manifest_name
				echo "" | tee -a $manifest_name
			 done
			 ;;
			$API_DIV)
			 # �����ʳ���ʸ��������å�
			 err_div_num=`echo -n $DIV_NUM | sed 's/[0-9]//g' `
			 if [ ! $err_div_num ] && [ $DIV_NUM ] && [ $DIV_NUM -gt 0 ]
			 then
			 	div_num=$DIV_NUM
			 else
			 	div_num=0
			 	while [ $div_num -lt 1 ]
			 	do
			 		echo -n "$INPUT_DIV_NUM "
			 		read div_num
			 		err_div_num=`echo -n $div_num | sed 's/[0-9]//g' `
			 		if [ $err_div_num ] || [ $div_num -lt 1 ]
			 		then
			 			echo "$div_num $ERR_INVALID_NO"
			 			div_num=0
			 		fi
			 	done
			 fi
			 all_step=0
			 pre_loop=0
			 post_loop=0
			 cnt=1

			 all_step=`cat temp_aut | wc -l`
			 each_step=`expr $all_step / $div_num`
			 remainder=`expr $all_step % $div_num`
			 while [ $cnt -le $div_num ]
			 do
			 	if [ $pre_loop -lt `expr $div_num - $remainder` ]
			 	then
			 		cat temp_aut | tail -n `expr $all_step - $each_step \* $pre_loop` | head -n $each_step | tee -a $manifest_name
			 		echo ""  | tee -a $manifest_name
			 		pre_loop=`expr $pre_loop + 1`
			 	else
			 		cat temp_aut | tail -n `expr $all_step - $each_step \* $pre_loop - \( $each_step + 1 \) \* $post_loop` | head -n `expr $each_step + 1` | tee -a $manifest_name
			 		echo ""  | tee -a $manifest_name
			 		post_loop=`expr $post_loop + 1`
			 	fi
			 	cnt=`expr $cnt + 1`
			 done
			 ;;
		esac
	fi
	rm -f temp_aut
	cd $TTSP_DIR
}

# ������å������ɥƥ��Ȥȥ���ե�����졼����󥨥顼�ƥ��Ȥ�
# �ޥ˥ե����Ⱥ���
make_manifest_for_scr_and_err()
{
	flg=0

	if [ "$kind" == "$SCRATCH" ]
	then
		temp="temp_scr"
	elif [ "$kind" == "$CONF_ERR" ]
	then
		temp="temp_err"
	fi

	mkdir -p $OBJECT_DIR/$root_dir
	cd $OBJECT_DIR/$root_dir
	rm -f $temp
	rm -f $manifest_name
	for dir in ${API_TEST_DIR[@]}
	do
		check_dir_name=../../$dir
		check_dir
		if [ $? -ne 1 ]
		then
			api_test_dir=`get_realpath ../../$dir`
			find $api_test_dir/ -name "*.cfg" -print >> $temp
			flg=1
		fi
	done
	if [ $flg = 1 ]
	then
		while read line
		do
			dir_path=${line%/*}
			case $kind in
				"$SCRATCH")
				 if [ -f $dir_path/$ERR_CODE ]
				 then
				 	grep $WARNING $dir_path/$ERR_CODE &> /dev/null
				 	if [ $? = 1 ]
				 	then
				 		continue
				 	fi
				 fi
				 vari_flg=0
				 variation_check
				 if [ $vari_flg = 1 ]
				 then
				 	continue
				 fi
				 echo $dir_path | tee -a $manifest_name
				 ;;
				"$CONF_ERR")
				 if [ ! -f $dir_path/$ERR_CODE ]
				 then
				 	continue
				 fi
				 vari_flg=0
				 variation_check
				 if [ $vari_flg = 1 ]
				 then
				 	continue
				 fi
				 echo $dir_path | tee -a $manifest_name
				 ;;
			esac
		done < $temp
	fi
	rm -f $temp
	cd $TTSP_DIR
}

# TESRY���Ѥ����ƥ��ȤΥƥ����ѥե��������
make_directory_for_tesry()
{
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

	rm -rf $OBJECT_DIR/$root_dir/$pre_dir_name\_*
	mkdir -p $OBJECT_DIR/$root_dir/temp_dir_aut
	cd $OBJECT_DIR/$root_dir/temp_dir_aut
	perl ../../../../configure $CONFIG_TEST_PROGRAM "$INCLUDE_DIR" &> /dev/null
	cd ../
	rm -f temp_aut
	cnt=1
	while read line
	do
		if [ $line ]
		then
			flg=0
			echo $line >> temp_aut
		else
			if [ $flg -eq 0 ]
			then
				# �ե�����ȥե������Υޥ˥ե����ȥե��������
				mkdir $pre_dir_name\_$cnt
				echo "$PRE_MAKE_DIRECTORY "$pre_dir_name\_$cnt" $POST_MAKE_DIRECTORY"
				mv temp_aut $pre_dir_name\_$cnt/$manifest_name\_$cnt
				cp -p temp_dir_aut/$MAKE_FILE_NAME ./$pre_dir_name\_$cnt
				cnt=`expr $cnt + 1 `
				flg=1
			fi
		fi
	done < $manifest_name
	if [ $flg -eq 0 ]
	then
		mkdir $pre_dir_name\_$cnt
		echo "$PRE_MAKE_DIRECTORY "$pre_dir_name\_$cnt" $POST_MAKE_DIRECTORY"
		mv temp_aut $pre_dir_name\_$cnt/$manifest_name\_$cnt
		cp -p temp_dir_aut/$MAKE_FILE_NAME ./$pre_dir_name\_$cnt
	fi

	rm -rf temp_dir_aut
	cd $TTSP_DIR
}

# ������å������ɥƥ��ȡ�����ե�����졼����󥨥顼�ƥ��Ȥ�
# �ƥ����ѥե��������
make_directory_for_scr_and_err()
{
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

	if [ "$kind" == "$SCRATCH" ]
	then
		temp_dir="temp_dir_scr"
	elif [ "$kind" == "$CONF_ERR" ]
	then
		temp_dir="temp_dir_err"
	fi

	rm -rf $OBJECT_DIR/$root_dir/$sub_dir/*/
	mkdir -p $OBJECT_DIR/$root_dir/$sub_dir/$temp_dir
	cd $OBJECT_DIR/$root_dir/$sub_dir/$temp_dir
	perl ../../../../../configure $CONFIG_TEST_PROGRAM  "$INCLUDE_DIR" &> /dev/null
	cd ../

	for dir in ${test_case_list[@]}
	do
		if [ -d $dir ]
		then
			dir_name=${dir##*/}
			echo "$PRE_MAKE_DIRECTORY $dir_name $POST_MAKE_DIRECTORY"
			mkdir $dir_name  &> /dev/null
			cp -p $temp_dir/$MAKE_FILE_NAME ./$dir_name
			cp -p $dir/* ./$dir_name
			cd $dir_name
			rename_scratch_program
			cd ../
		fi
	done
	rm -rf $temp_dir
	cd $TTSP_DIR
}

# TTG�¹�(�ޥ˥ե����ȥե����뤬������)
execute_ttg_for_manifest()
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
			list_num=`expr $list_num - 1`
			cnt=`expr $cnt + 1`
			dir_name=$pre_dir_name\_$cnt
			if [ ! -d $dir_name ]
			then
				list_num=`expr $list_num + 1`
				continue
			fi
			header_single "$TTG_IN $dir_name"
			check_file_name=$dir_name/$manifest_name\_$cnt
			check_file
			if [ $? -eq 1 ]
			then
				continue
			fi
			check_empty_file
			if [ $? -eq 1 ]
			then
				continue
			fi
				exclusion_comment_out
				cd $dir_name
				execute_ttg
				cd ../
		done
	fi
	cd $TTSP_DIR
}

# TTG�¹�(����TESRY�ǡ�����ƥ��Ȥ�����)
execute_ttg_for_no_manifest()
{
	test_case_list=""
	check_dir_name=$OBJECT_DIR/$root_dir/$dir_name
	check_dir
	if [ $? -eq 1 ]
	then
		return
	fi
	if [ ! "$SPEC_YAML" ]
	then
		echo -n "$INPUT_YAML "
		read input_yaml
	else
		input_yaml="$SPEC_YAML"
	fi
	for yaml_path in ${input_yaml[@]}
	do
		if [ -f $yaml_path ]
		then
			test_case_list="$test_case_list "$yaml_path
		else
			find $yaml_path/ -name "*.yaml" > temp_tesry
			sed -i -e "/\/\.svn/d" temp_tesry # omit svn�ե�����
			while read line
			do
				test_case_list="$test_case_list "$line
			done < temp_tesry
		fi
	done
	rm -f temp_tesry

	if [ ! "$test_case_list" ]
	then
		echo "$ERR_PATH_FAIL"
		cd $TTSP_DIR
		return
	fi
	header_single "$TTG_IN $dir_name"
	cd $OBJECT_DIR/$root_dir/$SPECIFIED_YAML_DIR_NAME
	execute_ttg
	cd $TTSP_DIR
}

# ���̥ե�����Ǥ�TTG�¹�(�����ȥ����ɥƥ���)
execute_ttg_for_operate_directory()
{
	check_file_name=$MNF_API_TESRY\_$cnt
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

	# TTG�¹�
	header_single "$TTG_IN $dir_name"
	execute_ttg
}

# ���̥ե�����Ǥ�Makefile���Ѥ��ƹԤ�����(make depend, make, 
# make clean, make realclean)�μ¹�(�����ȥ����ɥƥ���)
make_for_operate_directory()
{
	appli_name=$APPLI_NAME
	substitution_file_name
	check_file
	if [ $? -eq 1 ]
	then
		return
	fi
	make_for_common
}

# ����ե�����졼����󥨥顼�ƥ��Ȥ�err_code.txt�ȼ¹ԥ��顼�����
compare_error_code()
{
	cd $dir_name
	rename_scratch_program
	make realclean $MAKE_OPT KERNEL_COBJS="$KERNEL_COBJS_COMMON $KERNEL_COBJS_TARGET" &> /dev/null
	make depend $MAKE_OPT KERNEL_COBJS="$KERNEL_COBJS_COMMON $KERNEL_COBJS_TARGET" 1> /dev/null 2> $RESULT_MAKE_DEPEND
	err_code=`cat $ERR_CODE | sed -e s/'\*'/'\\\*'/g`
	grep "$err_code" $RESULT_MAKE_DEPEND > /dev/null
	if [ $? -eq 0 ]
	then
		echo "$dir_name $TEST_OK" | tee -a ../$RESULT_CONF_ERR
		cd ../
		continue
	fi
	make $MAKE_OPT KERNEL_COBJS="$KERNEL_COBJS_COMMON $KERNEL_COBJS_TARGET" 1> /dev/null 2> $RESULT_MAKE
	grep "$err_code" $RESULT_MAKE > /dev/null
	if [ $? -eq 0 ]
	then
		echo "$dir_name $TEST_OK" | tee -a ../$RESULT_CONF_ERR
	else
		echo "$dir_name $TEST_NG $ERR_CODE" | tee -a ../$RESULT_CONF_ERR
	fi
	cd ../
}

# ����ե�����졼����󥨥顼�ƥ��ȼ¹�
check_configuration_error()
{
	test_num=0
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
	echo $SINGLE_LINE > $RESULT_CONF_ERR
	echo $CHK_CFG_ERR >> $RESULT_CONF_ERR
	echo $SINGLE_LINE >> $RESULT_CONF_ERR
	
	for dir in ${test_case_list[@]}
	do
		test_num=`expr $test_num + 1`
		check_dir_name=$dir
		check_dir
		if [ $? -eq 1 ]
		then
			continue
		else
			dir_name=${dir##*/}
			compare_error_code
		fi
	done
	cd $TTSP_DIR

	# �¹Է��ɽ��
	success_num=`grep "$TEST_OK" $OBJECT_DIR/$root_dir/$sub_dir/$RESULT_CONF_ERR | wc -l`
	output_config_err_test_result
}

# �ƥ��ȥ�������˥ե����������TTG��make depend��make�¹�
# (�����ȥ����ɥƥ���)
continuous_execute_for_tesry()
{
	result_step=0

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

	rm -rf $OBJECT_DIR/$root_dir/$pre_dir_name\_*

	mkdir -p $OBJECT_DIR/$root_dir/temp_dir_aut
	cd $OBJECT_DIR/$root_dir/temp_dir_aut
	perl ../../../../configure $CONFIG_TEST_PROGRAM "$INCLUDE_DIR" &> /dev/null
	check_file_name=$MAKE_FILE_NAME
	check_file
	if [ $? -eq 1 ]
	then
		echo "$ERR_CREAT_MAKEFILE_FAIL"
		return
	fi

	cd ../
	rm -f temp_aut
	cnt=1
	while read line
	do
		if [ $line ]
		then
			flg=0
			echo $line >> temp_aut
		else
			if [ $flg -eq 0 ]
			then
				# �ե�����ȥե������Υޥ˥ե����ȥե��������
				dir_name=$pre_dir_name\_$cnt
				mkdir $dir_name
				echo "$PRE_MAKE_DIRECTORY "$dir_name" $POST_MAKE_DIRECTORY"
				mv temp_aut $dir_name/$manifest_name\_$cnt
				cp -p temp_dir_aut/$MAKE_FILE_NAME ./$dir_name

				cd $dir_name
				# TTG�¹�
				header_single "$TTG_IN $dir_name"
				check_file_name=$manifest_name\_$cnt
				exclusion_comment_out
				execute_ttg

				# make depend�¹�
				if [ $? -eq 0 ]
				then
					rule=$RULE_DEPEND
					make_for_common

					# make�¹�
					if [ $? -eq 0 ]
					then
						rule=$RULE_BUILD
						make_for_common
					else
						echo "$ERR_DEPEND_FAIL "$dir_name
					fi
				else
					echo "$ERR_TTG_FAIL "$dir_name
				fi

				cnt=`expr $cnt + 1 `
				flg=1
				echo ""
				cd ../
			fi
		fi
	done < $manifest_name
	if [ $flg -eq 0 ]
	then
		# �ե�����ȥե������Υޥ˥ե����ȥե��������
		dir_name=$pre_dir_name\_$cnt
		mkdir $dir_name
		echo "$PRE_MAKE_DIRECTORY "$dir_name" $POST_MAKE_DIRECTORY"
		mv temp_aut $dir_name/$manifest_name\_$cnt
		cp -p temp_dir_aut/$MAKE_FILE_NAME ./$dir_name

		cd $dir_name
		# TTG�¹�
		header_single "$TTG_IN $dir_name"
		check_file_name=$manifest_name\_$cnt
		exclusion_comment_out
		execute_ttg

		# make depend�¹�
		if [ $? -eq 0 ]
		then
			rule=$RULE_DEPEND
			make_for_common

			# make�¹�
			if [ $? -eq 0 ]
			then
				rule=$RULE_BUILD
				make_for_common
			else
				echo "$ERR_DEPEND_FAIL "$dir_name
			fi
		else
			echo "$ERR_TTG_FAIL "$dir_name
		fi
	fi

	cd $TTSP_DIR
	rm -rf $OBJECT_DIR/$root_dir/temp_dir_aut
}

# ���̥ե�����Ǥ�TTG��make depend��make�¹�(�����ȥ����ɥƥ���)
continuous_execute_for_operate_directory()
{
	check_file_name=$MNF_API_TESRY\_$cnt
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

	# TTG�¹�
	header_single "$TTG_IN $dir_name"
	execute_ttg

	# make depend�¹�
	if [ $? -eq 0 ]
	then
		check_file_name=$MAKE_FILE_NAME
		check_file
		if [ $? -eq 1 ]
		then
			return
		fi
		rule=$RULE_DEPEND
		make_for_common

		# make�¹�
		if [ $? -eq 0 ]
		then
			rule=$RULE_BUILD
			make_for_common
		else
			echo "$ERR_DEPEND_FAIL "$dir_name
		fi
	else
		echo "$ERR_TTG_FAIL "$dir_name
	fi

}

# �ƥ��ȥ�������˥ե����������make depend��make�¹�
# (������å������ɥƥ��Ȥȥ���ե�����졼����󥨥顼�ƥ���)
continuous_execute_for_scr_and_err()
{
	test_num=0

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

	if [ "$kind" == "$SCRATCH" ]
	then
		temp_dir="temp_dir_scr"
	elif [ "$kind" == "$CONF_ERR" ]
	then
		temp_dir="temp_dir_err"
	fi

	rm -rf $OBJECT_DIR/$root_dir/$sub_dir/*/
	mkdir -p $OBJECT_DIR/$root_dir/$sub_dir/$temp_dir
	cd $OBJECT_DIR/$root_dir/$sub_dir/$temp_dir
	perl ../../../../../configure $CONFIG_TEST_PROGRAM  "$INCLUDE_DIR" &> /dev/null
	check_file_name=$MAKE_FILE_NAME
	check_file
	if [ $? -eq 1 ]
	then
		echo "$ERR_CREAT_MAKEFILE_FAIL"
		return
	fi
	cd ../

	if [ "$kind" = "$CONF_ERR" ]
	then
		echo $SINGLE_LINE > $RESULT_CONF_ERR
		echo $CHK_CFG_ERR >> $RESULT_CONF_ERR
		echo $SINGLE_LINE >> $RESULT_CONF_ERR
	fi
	for dir in ${test_case_list[@]}
	do
		if [ -d $dir ]
		then
			# �ե��������
			dir_name=${dir##*/}
			if [ $test_num -ne 0 ]
			then
				echo ""
			fi
			test_num=`expr $test_num + 1`
			echo "$PRE_MAKE_DIRECTORY $dir_name $POST_MAKE_DIRECTORY"
			mkdir $dir_name  &> /dev/null
			cp -p $temp_dir/$MAKE_FILE_NAME ./$dir_name
			cp -p $dir/* ./$dir_name
			case $kind in
				"$SCRATCH")
				 # make depend�¹�
				 rule=$RULE_DEPEND
				 cd $dir_name
				 rename_scratch_program
				 appli_name=$APPLI_NAME
				 substitution_file_name
				 check_file
				 if [ $? -ne 1 ]
				 then
				 	make_for_common

				 	# make�¹�
				 	if [ $? -eq 0 ]
				 	then
				 		rule=$RULE_BUILD
				 		make_for_common
				 	else
				 		echo "$ERR_DEPEND_FAIL "$dir_name
				 	fi
				 fi
				 cd ../
				 ;;
				"$CONF_ERR")
				 compare_error_code
				 ;;
			esac
		fi
	done
	rm -rf $temp_dir
	cd $TTSP_DIR

	if [ "$kind" = "$CONF_ERR" ]
	then
		# �¹Է��ɽ��
		success_num=0
		success_num=`grep "$TEST_OK" $OBJECT_DIR/$root_dir/$sub_dir/$RESULT_CONF_ERR | wc -l`
		output_config_err_test_result
	fi
}

# ����TESRY�ǡ����Υե����������TTG��make depend��make�¹�
continuous_execute_for_specified_yaml()
{
	result_step=0

	test_case_list=""
	rm -rf $OBJECT_DIR/$root_dir/$dir_name
	echo "$PRE_MAKE_DIRECTORY $dir_name $POST_MAKE_DIRECTORY"
	mkdir -p $OBJECT_DIR/$root_dir/$dir_name
	cd $OBJECT_DIR/$root_dir/$dir_name
	rm -f temp_ttg
	perl ../../../../configure $CONFIG_TEST_PROGRAM "$INCLUDE_DIR" &> /dev/null
	check_file_name=$MAKE_FILE_NAME
	check_file
	if [ $? -eq 1 ]
	then
		echo "$ERR_CREAT_MAKEFILE_FAIL"
		return
	fi

	if [ ! "$SPEC_YAML" ]
	then
		echo -n "$INPUT_YAML "
		read input_yaml
	else
		input_yaml="$SPEC_YAML"
	fi

	for yaml_path in ${input_yaml[@]}
	do
		if [ -f $yaml_path ]
		then
			test_case_list="$test_case_list "$yaml_path
		else
			find $yaml_path/ -name "*.yaml" > temp_ttg
			sed -i -e "/\/\.svn/d" temp_ttg # omit svn�ե�����
			while read line
			do
				test_case_list="$test_case_list "$line
			done < temp_ttg
		fi
	done
	rm -f temp_ttg

	if [ ! "$test_case_list" ]
	then
		echo "$ERR_PATH_FAIL"
		cd $TTSP_DIR
		return
	fi
	# TTG�¹�
	header_single "$TTG_IN $dir_name"
	execute_ttg

	# make depend�¹�
	if [ $? -eq 0 ]
	then
		rule=$RULE_DEPEND
		make_for_common

		# make�¹�
		if [ $? -eq 0 ]
		then
			rule=$RULE_BUILD
			make_for_common
		else
			echo "$ERR_DEPEND_FAIL "$dir_name
		fi
	else
		echo "$ERR_TTG_FAIL "$dir_name
	fi
	cd $TTSP_DIR
}

# TTG�μ¹�
execute_ttg()
{
	args="$TTG_OPT $test_case_list"
	( ruby $ttg_bin $args 3>&1 1>&2  2>&3; echo $? >status_file ) | tee $RESULT_TTG
	sed -i -e "s/^.*\r//g" ./$RESULT_TTG
	status=`cat status_file`
	rm -rf status_file
	return $status
}

if [ $go_api_test_flg == 0 ]
then
	# TTG�ؤΥѥ�
	ttg_bin=`get_realpath ./$TTG_BIN`

	# TTG���ץ�������
	if [ $PROFILE_NAME = "FMP" ]
	then
	  TTG_OPT=`echo "-f $TTG_OPT --prc_num $PROCESSOR_NUM --timer_arch $TIMER_ARCH --out_file_name $APPLI_NAME \
	                 --func_time $FUNC_TIME --func_interrupt $FUNC_INTERRUPT --func_exception $FUNC_EXCEPTION --irc_arch $IRC_ARCH"`
	  CONFIG_PRC="-P $PROCESSOR_NUM"
	else
	  TTG_OPT=`echo "-a $TTG_OPT --out_file_name $APPLI_NAME --func_time $FUNC_TIME --func_interrupt $FUNC_INTERRUPT --func_exception $FUNC_EXCEPTION"`
	fi

	#
	# �������åȰ�¸��configure.yaml��¸�ߤ���С�TTG_OPT�˻���
	#
	if [ -f ./library/$PROFILE_NAME/target/$TARGET_NAME/configure.yaml ]
	then
		configure_path=`get_realpath ./library/$PROFILE_NAME/target/$TARGET_NAME/configure.yaml`
		TTG_OPT="-c $configure_path $TTG_OPT"
	fi
	go_api_test_flg=1
fi

# ��������
api_test_main
