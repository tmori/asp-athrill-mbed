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
#  $Id: kernel_lib.sh 2 2012-05-09 02:23:52Z nces-shigihara $
# 

# �����ͥ�饤�֥������ᥤ���˥塼
kernel_lib_main()
{
	while true
	do
		cat<<EOS

$DOUBLE_LINE
 $KERNEL_LIBRARY_MENU
$DOUBLE_LINE
 1: $L_ALL
 2: $L_MKDIR
 3: $L_DEPEND
 4: $L_BUILD
 5: $L_CLEAN
 6: $L_REALCLEAN
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
			 header_double "$L_ALL"
			 build_kernel_library
			 ;;
			2)
			 header_double "$L_MKDIR"
			 rm -rf $KERNEL_LIB
			 mkdir -p $KERNEL_LIB
			 cd $KERNEL_LIB
			 perl ../../configure $CONFIG_KERNEL_LIB "$INCLUDE_DIR"
			 cd $TTSP_DIR
			 ;;
			3)
			 header_double "$L_DEPEND"
			 rule=$RULE_DEPEND
			 dir_name=$KERNEL_LIB
			 appli_name=$L_APPLI_NAME
			 make_for_no_manifest
			 ;;
			4)
			 header_double "$L_BUILD"
			 rule=$RULE_BUILD
			 dir_name=$KERNEL_LIB
			 appli_name=$L_APPLI_NAME
			 make_for_no_manifest
			 ;;
			5)
			 header_double "$L_CLEAN"
			 rule=$RULE_CLEAN
			 dir_name=$KERNEL_LIB
			 make_for_no_manifest
			 ;;
			6)
			 header_double "$L_REALCLEAN"
			 rule=$RULE_REALCLEAM
			 dir_name=$KERNEL_LIB
			 make_for_no_manifest
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

build_kernel_library()
{
	rm -rf $KERNEL_LIB
	mkdir -p $KERNEL_LIB
	cd $KERNEL_LIB
	perl ../../configure $CONFIG_KERNEL_LIB "$INCLUDE_DIR" 
	( make depend $MAKE_OPT KERNEL_COBJS="$KERNEL_COBJS_COMMON $KERNEL_COBJS_TARGET" 2>&1; echo $? >status_file ) | tee $RESULT_MAKE_DEPEND
	status=`cat status_file`
	rm -rf status_file
	if [ $status = 0 ]
	then
		make $MAKE_OPT KERNEL_COBJS="$KERNEL_COBJS_COMMON $KERNEL_COBJS_TARGET" 2>&1 | tee $RESULT_MAKE
	else
		echo "$ERR_DEPEND_FAIL "$KERNEL_LIB
	fi
	cd $TTSP_DIR
}

# ��������
kernel_lib_main
