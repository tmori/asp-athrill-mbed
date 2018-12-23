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
#  $Id: Eventflag.rb 9 2012-09-11 01:47:48Z nces-shigihara $
#
require "ttc/bin/sc_object/SCObject.rb"

#=====================================================================
# CommonModule
#=====================================================================
module CommonModule
  #===================================================================
  # ���饹̾: Eventflag
  # ��    ��: ���٥�ȥե饰�ξ����������륯�饹
  #===================================================================
  class Eventflag < SCObject
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
                  case atr
                  when TSR_VAR_WAIPTN
                    check_attribute_unsigned(atr, val, aPath)
                  when TSR_VAR_WFMODE
                    check_attribute_type(atr, val, String, false, aPath)
                    check_attribute_enum(atr, val, GRP_EVENTFLAG_MODE, aPath)
                  when TSR_VAR_VAR
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
            else
              sErr = sprintf(ERR_LIST_ITEM_INVALID_TYPE, sAtr, Hash, hData.class())
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

      # flgatr
      unless (is_specified?(TSR_PRM_FLGATR))
        @hState[TSR_PRM_ATR] = "ANY_ATT_FLG"
      end
      # iflgptn
      unless (is_specified?(TSR_PRM_IFLGPTN))
        @hState[TSR_PRM_IFLGPTN] = "BIT_PATTERN_0A"
      end
      # flgptn
      unless (is_specified?(TSR_PRM_FLGPTN))
        @hState[TSR_PRM_FLGPTN]  = "BIT_PATTERN_A"
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
                  hVars[sTask][sVarName] = [TYP_FLGPTN]
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
