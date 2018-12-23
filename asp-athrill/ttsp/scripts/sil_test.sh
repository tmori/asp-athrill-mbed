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
#  $Id: sil_test.sh 2 2012-05-09 02:23:52Z nces-shigihara $
# 

# SIL�ƥ��ȥ�˥塼
sil_test_main()
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
 $SIL_TEST_MENU
$DOUBLE_LINE
 1: $SIL_ALL_BUILD
 2: $SIL_MAKE_DIR
 3: $SIL_MAKE_DEPEND
 4: $SIL_MAKE_BUILD
 5: $SIL_MAKE_CLEAN
 6: $SIL_MAKE_REALCLEAN
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
			 header_double "$SIL_ALL_BUILD"
			 dir_name=$SIL_TEST_ROOT
			 continuous_execute_for_sil_test
			 ;;
			2)
			 header_double "$SIL_MAKE_DIR"
			 dir_name=$SIL_TEST_ROOT
			 make_directory_for_sil_test
			 ;;
			3)
			 header_double "$SIL_MAKE_DEPEND"
			 rule=$RULE_DEPEND
			 dir_name=$SIL_TEST_ROOT
			 make_for_sil_test
			 ;;
			4)
			 header_double "$SIL_MAKE_BUILD"
			 rule=$RULE_BUILD
			 dir_name=$SIL_TEST_ROOT
			 make_for_sil_test
			 ;;
			5)
			 header_double "$SIL_MAKE_CLEAN"
			 rule=$RULE_CLEAN
			 dir_name=$SIL_TEST_ROOT
			 make_for_sil_test
			 ;;
			6)
			 header_double "$SIL_MAKE_REALCLEAN"
			 rule=$RULE_REALCLEAM
			 dir_name=$SIL_TEST_ROOT
			 make_for_sil_test
			 ;;
			e)
			 header_double "RUN_EXEC_MODULE"
			 kind="$SIL_TEST_MENU"
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
			go_main_flg=0
			break
		fi
		
	done
}

# �ե��������
make_directory_for_sil_test()
{
	rm -rf $OBJECT_DIR/$dir_name
	echo "$PRE_MAKE_DIRECTORY $dir_name $POST_MAKE_DIRECTORY"
	mkdir -p $OBJECT_DIR/$dir_name
	cd $OBJECT_DIR/$dir_name
	perl ../../../configure $CONFIG_TEST_PROGRAM "$INCLUDE_DIR" &> /dev/null
	cp -p $TTSP_DIR/$SIL_TEST_DIR/* .
	rename_scratch_program
	cd $TTSP_DIR
}

# Makefile���Ѥ�������μ¹�
make_for_sil_test()
{
	check_dir_name=$OBJECT_DIR/$dir_name/
	check_dir
	if [ $? -eq 0 ]
	then
		cd $OBJECT_DIR/$dir_name/
		case $rule in
			$RULE_DEPEND)
			 check_file_name="$APPLI_NAME.c \
			                  $APPLI_NAME.h \
			                  $APPLI_NAME.cfg \
			                  $MAKE_FILE_NAME"
			 ;;
			$RULE_BUILD)
			 check_file_name="$APPLI_NAME.c \
			                  $APPLI_NAME.h \
			                  $APPLI_NAME.cfg \
			                  $MAKE_FILE_NAME"
			 ;;
			$RULE_CLEAN)
			 check_file_name="$MAKE_FILE_NAME"
			 ;;
			$RULE_REALCLEAM)
			 check_file_name="$MAKE_FILE_NAME"
			 ;;
		esac
		check_file
		make_for_common
	fi
	cd $TTSP_DIR

}

# �ե����������make depend��make�¹�
continuous_execute_for_sil_test()
{
	rm -rf $OBJECT_DIR/$dir_name
	echo "$PRE_MAKE_DIRECTORY $dir_name $POST_MAKE_DIRECTORY"
	mkdir -p $OBJECT_DIR/$dir_name
	cd $OBJECT_DIR/$dir_name
	perl ../../../configure $CONFIG_TEST_PROGRAM "$INCLUDE_DIR" &> /dev/null
	cp -p $TTSP_DIR/$SIL_TEST_DIR/* .
	rename_scratch_program

	# make depend�¹�
	rule=$RULE_DEPEND
	check_file_name="$APPLI_NAME.c \
                     $APPLI_NAME.h \
                     $APPLI_NAME.cfg \
                     $MAKE_FILE_NAME"
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
	cd $TTSP_DIR
}

# ��������
sil_test_main
