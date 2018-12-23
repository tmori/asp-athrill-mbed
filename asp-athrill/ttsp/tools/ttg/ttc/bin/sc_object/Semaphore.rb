#!ruby -Ke
#
#  TTG
#      TOPPERS Test Generator
#
#  Copyright (C) 2009-2012 by Center for Embedded Computing Systems
#              Graduate School of Information Science, Nagoya Univ., JAPAN
#  Copyright (C) 2010-2011 by Graduate School of Information Science,
#                             Aichi Prefectural Univ., JAPAN
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
#  $Id: Semaphore.rb 9 2012-09-11 01:47:48Z nces-shigihara $
#
require "ttc/bin/sc_object/SCObject.rb"

#=====================================================================
# CommonModule
#=====================================================================
module CommonModule
  #===================================================================
  # ���饹̾: Semaphore
  # ��    ��: ���ޥե��ξ����������륯�饹
  #===================================================================
  class Semaphore < SCObject
    #=================================================================
    # ��  ��: °�������å�
    #=================================================================
    def attribute_check()
      aErrors = []
      begin
        super()
      rescue TTCMultiError
        aErrors = $!.aErrors
      end

      begin
        # wtsklist
        sAtr = TSR_PRM_WTSKLIST
        if (is_specified?(sAtr))
          cProc = Proc.new(){|val, aPath|
            unless (val.nil?())
              sErr = sprintf(ERR_LIST_ITEM_INVALID_TYPE, sAtr, NilClass, val.class())
              raise(YamlError.new(sErr, aPath))
            end
          }
          attribute_check_task_list(sAtr, @hState[sAtr], cProc)
        end
      rescue YamlError
        aErrors.push($!)
      rescue TTCMultiError
        aErrors.concat($!.aErrors)
      end

      check_error(aErrors)
    end

    #=================================================================
    # ��  ��: ���֥������ȥ����å�
    #=================================================================
    def object_check(bIsPre)
      check_class(Bool, bIsPre)  # pre_condition��

      aErrors = []
      begin
        super(bIsPre)
      rescue TTCMultiError
        aErrors.concat($!.aErrors)
      end

      ### T3_SEM001: ����񸻿���isemcnt�ˤ�����񸻿���maxsem�ˤ���礭��
      if (@hState[TSR_PRM_ISEMCNT] > @hState[TSR_PRM_MAXSEM])
        sErr = sprintf("T3_SEM001: " + ERR_OVER_THAN_MAXSEM, TSR_PRM_ISEMCNT)
        aErrors.push(YamlError.new(sErr, @aPath))
      end
      ### T3_SEM002: ���߻񸻿���semcnt�ˤ�����񸻿���maxsem�ˤ���礭��
      if (@hState[TSR_PRM_SEMCNT] > @hState[TSR_PRM_MAXSEM])
        sErr = sprintf("T3_SEM002: " + ERR_OVER_THAN_MAXSEM, TSR_PRM_SEMCNT)
        aErrors.push(YamlError.new(sErr, @aPath))
      end

      check_error(aErrors)
    end

    #=================================================================
    # ��  ��: ����ͤ��䴰����
    #=================================================================
    def complement_init_object_info()
      super()

      # sematr
      unless (is_specified?(TSR_PRM_SEMATR))
        @hState[TSR_PRM_ATR] = "ANY_ATT_SEM"
      end
      # maxsem
      unless (is_specified?(TSR_PRM_MAXSEM))
        @hState[TSR_PRM_MAXSEM]  = "ANY_MAX_SEMCNT"
      end
      # isemcnt
      unless (is_specified?(TSR_PRM_ISEMCNT))
        @hState[TSR_PRM_ISEMCNT] = "ANY_INI_SEMCNT"
      end
      # semcnt
      unless (is_specified?(TSR_PRM_SEMCNT))
        @hState[TSR_PRM_SEMCNT]  = "ANY_NOW_SEMCNT"
      end
    end
  end
end
