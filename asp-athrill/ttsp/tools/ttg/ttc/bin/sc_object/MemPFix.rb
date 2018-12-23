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
#  $Id: MemPFix.rb 9 2012-09-11 01:47:48Z nces-shigihara $
#
require "ttc/bin/sc_object/SCObject.rb"

#=====================================================================
# CommonModule
#=====================================================================
module CommonModule
  #===================================================================
  # ���饹̾: MemPFix
  # ��    ��: ����Ĺ����ס���ξ����������륯�饹
  #===================================================================
  class MemPFix < SCObject
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
          cProc = Proc.new(){|hData, aPath|
            if (hData.is_a?(Hash))
              aProcErrors = []
              hData.each{|atr, val|
                begin
                  if (atr == TSR_VAR_VAR)
                    check_attribute_variable(atr, val, aPath)
                  else
                    sErr = sprintf(ERR_UNDEFINED_KEY, atr)
                    raise(YamlError.new(sErr, aPath))
                  end
                rescue YamlError
                  aProcErrors.push($!)
                end
              }
              check_error(aProcErrors)
            elsif (!hData.nil?())
              sErr = sprintf(ERR_LIST_ITEM_INVALID_TYPE_NIL, sAtr, Hash, hData.class())
              raise(YamlError.new(sErr, aPath))
            end
          }
          attribute_check_task_list(sAtr, @hState[sAtr], cProc)
        end
      rescue TTCMultiError
        aErrors.concat($!.aErrors)
      end

      check_error(aErrors)
    end

    #=================================================================
    # ��  ��: ����ͤ��䴰����
    #=================================================================
    def complement_init_object_info()
      super()

      # mpfatr
      unless (is_specified?(TSR_PRM_MPFATR))
        @hState[TSR_PRM_ATR] = "ANY_ATT_MPF"
      end
      # blkcnt
      unless (is_specified?(TSR_PRM_BLKCNT))
        @hState[TSR_PRM_BLKCNT] = "ANY_INI_BLKCNT"
      end
      # fblkcnt
      unless (is_specified?(TSR_PRM_FBLKCNT))
        @hState[TSR_PRM_FBLKCNT] = "ANY_NOW_BLKCNT"
      end
      # blksz
      unless (is_specified?(TSR_PRM_BLKSZ))
        @hState[TSR_PRM_BLKSZ] = "ANY_BLKSZ"
      end
    end

    #=================================================================
    # ��  ��: �Ԥ��������ꥹ������ѿ��ȷ����Ȥ߹�碌�������֤�
    #=================================================================
    def get_wtsklist_variable()
      hVars = {}
      unless (@hState[TSR_PRM_WTSKLIST].nil?())
        @hState[TSR_PRM_WTSKLIST].each{|hTask|
          hTask.each{|sTask, hData|
            unless (hData.nil?())
              hVars[sTask] = {}
              hData.each{|sAtr, sVarName|
                if (sAtr == TSR_VAR_VAR)
                  hVars[sTask][sVarName] = [TYP_VOID_P]
                end
              }
            end
          }
        }
      end

      return hVars  # [Hash]�Ԥ��������ꥹ������ѿ��ȷ����Ȥ߹�碌����
    end
  end
end
