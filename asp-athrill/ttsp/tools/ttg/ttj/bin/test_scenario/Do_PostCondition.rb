#!ruby -Ke
#
#  TTG
#      TOPPERS Test Generator
#
#  Copyright (C) 2009-2012 by Center for Embedded Computing Systems
#              Graduate School of Information Science, Nagoya Univ., JAPAN
#  Copyright (C) 2010-2011 by Digital Craft Inc.
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
#  $Id: Do_PostCondition.rb 9 2012-09-11 01:47:48Z nces-shigihara $
#

#=====================================================================
# CommonModule
#=====================================================================
module CommonModule
  #===================================================================
  # ���饹̾: Do_PostCondition
  # ��    ��: do��post_condition�ξ����������륯�饹
  #===================================================================
  class Do_PostCondition < Condition
    #=================================================================
    # ������: doʸ���ȥ���ǥ�Ȥȥ�����ƥ��å������ܸ첽�����塤
    #         ���ܸ첽���줿do�ξ����Ĥʤ����֤�
    #=================================================================
    def japanize_do_info(bSeqNum, bTimeTick, bCondFlag)
      check_class(Bool, bSeqNum)    # ���������ֹ��̵ͭ
      check_class(Bool, bTimeTick)  # ������ƥ��å���̵ͭ

      sIndent = TTJ_TAB  # do�δ��ܥ���ǥ��
      sAllDo  = ""       # ���ܸ첽���줿do�ξ�����ݻ����뤿����ѿ�

      # doʸ�������ܸ첽
      if (bCondFlag == true)
        sAllDo += "#{GRP_TTJ_CONDITION[TSR_LBL_DO]}#{(bSeqNum == true ? nSeqNum : "")}#{TTJ_NEW_LINE}"

        if (hDo.empty?() == true)
          return sAllDo += "#{sIndent}#{TTJ_DO_EMPTY}#{TTJ_NEW_LINE}#{TTJ_NEW_LINE}"  # [String]do�ξ��󤬤ʤ����Ȥ򼨤�ʸ����
        end
      end

      # do�˾��󤬤ʤ����
      if (hDo.empty?() == true)
        return ""  # [String]do�ξ��󤬤ʤ����Ȥ򼨤�ʸ����
      end

      # do�˥�����ƥ��å����󤬤����祿����ƥ��å����������
      # ������ƥ��å���������ӥ���ǥ�Ȥ�����
      if (bTimeTick == true)
        sAllDo  += "#{sIndent}#{nTimeTick}#{TTJ_NEW_LINE}"
        sIndent += "#{TTJ_TAB}"
      end

      # do�ξ�������ܸ첽����
      sAllDo = japanize_do(sAllDo, sIndent)
      sAllDo += "#{TTJ_NEW_LINE}#{TTJ_NEW_LINE}"

      return sAllDo  # [String]���ܸ첽���줿do�ξ���
    end

    #=================================================================
    # ������: post_conditionʸ���ȥ���ǥ�Ȥȥ�����ƥ��å���
    #         ���ܸ첽�����塤���ܸ첽���줿post_condition�ξ����
    #         �Ĥʤ����֤�
    #=================================================================
    def japanize_post_info(bSeqNum, bTimeTick, bCondFlag)
      check_class(Bool, bSeqNum)    # ���������ֹ��̵ͭ
      check_class(Bool, bTimeTick)  # ������ƥ��å���̵ͭ

      sIndent  = TTJ_TAB  # post_condition�δ��ܥ���ǥ��
      sAllPost = ""       # ���ܸ첽���줿post_condition�ξ�����ݻ����뤿����ѿ�

      # post_conditionʸ�������ܸ첽
      if (bCondFlag == true)
        sAllPost += "#{GRP_TTJ_CONDITION[TSR_LBL_POST]}#{(bSeqNum == true ? nSeqNum : "")}#{TTJ_NEW_LINE}"
      end

      # post_condition�˥�����ƥ��å����󤬤����祿����ƥ��å����������
      # ������ƥ��å���������ӥ���ǥ�Ȥ�����
      if (bTimeTick == true)
        sAllPost += "#{sIndent}#{nTimeTick}#{TTJ_NEW_LINE}"
        sIndent  += "#{TTJ_TAB}"
      end

      # do�ξ�������ܸ첽����
      sAllPost = japanize_condition_info(sAllPost, sIndent, TSR_LBL_POST)

      return sAllPost  # [String]���ܸ첽���줿post_condition�ξ���
    end

  end
end
