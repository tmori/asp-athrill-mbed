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
#  $Id: Mailbox.rb 9 2012-09-11 01:47:48Z nces-shigihara $
#
require "ttc/bin/sc_object/SCObject.rb"

#=====================================================================
# CommonModule
#=====================================================================
module CommonModule
  #===================================================================
  # ���饹̾: Mailbox
  # ��    ��: �᡼��ܥå����ξ����������륯�饹
  #===================================================================
  class Mailbox < SCObject
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

      begin
        # msglist
        sAtr = TSR_PRM_MSGLIST
        if (is_specified?(sAtr))
          check_attribute_type(sAtr, @hState[sAtr], Array, false, @aPath)
          aPath = @aPath + [sAtr]
          aTmpErrors = []
          @hState[sAtr].each_with_index{|hData, nIndex|
            # �ꥹ�Ȥ����Ǥ�Hash��
            unless (hData.is_a?(Hash))
              sErr = sprintf(ERR_LIST_INVALID_TYPE, sAtr, Hash, hData.class())
              raise(YamlError.new(sErr, aPath + [nIndex]))
            end
            # ���Ǥ����ƥ����å�
            hData.each{|atr, val|
              begin
                case atr
                when TSR_VAR_MSG
                  check_attribute_variable(atr, val, aPath + [nIndex])
                when TSR_VAR_MSGPRI
                  check_attribute_range(atr, val, TTC_MAX_PRI, TTC_MIN_PRI, aPath + [nIndex])
                else
                  sErr = sprintf(ERR_UNDEFINED_KEY, atr)
                  raise(YamlError.new(sErr, aPath + [nIndex]))
                end
              rescue YamlError
                aTmpErrors.push($!)
              end
            }
          }
          check_error(aTmpErrors)
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

      ### T3_MBX001: �᡼��ܥå�����°����TA_MPRI�λ��˼����Ԥ���å������ꥹ�ȤΥ�å�������
      ###          : ��å������إå��ѿ�̾��ͥ���٤�°�������Ҥ���Ƥ��ʤ�
      unless (@hState[TSR_PRM_MSGLIST].nil?())
        if (@hState[TSR_PRM_ATR] == KER_TA_MPRI)
          @hState[TSR_PRM_MSGLIST].each_with_index{|hData, index|
            if (hData[TSR_VAR_MSG].nil?() || hData[TSR_VAR_MSGPRI].nil?())
              aErrors.push(YamlError.new("T3_MBX001: " + ERR_MSGLIST_VARS_MUST_DEFINE, @aPath + [index]))
            end
          }
        ### T3_MBX002: �᡼��ܥå�����°����TA_MPRI�ʳ��λ��˼����Ԥ���å������ꥹ�ȤΥ�å�������
        ###          : ͥ���٤�°�������Ҥ���Ƥ���
        else
          @hState[TSR_PRM_MSGLIST].each_with_index{|hData, index|
            if (hData.has_key?(TSR_VAR_MSGPRI))
              aErrors.push(YamlError.new("T3_MBX002: " + ERR_CANNOT_BE_DEFINED_MSGPRI, @aPath + [index]))
            end
          }
        end
        ### T3_MBX003: msglist�Υꥹ�Ȥ�Ʊ���ѿ�����İʾ�¸�ߤ���
        aVarName = []
        @hState[TSR_PRM_MSGLIST].each{|hData|
          if (hData.has_key?(TSR_VAR_MSG))
            if (aVarName.include?(hData[TSR_VAR_MSG]))
              sErr = sprintf("T3_MBX003: " + ERR_MSGLIST_VAR_DUPLICATE, hData[TSR_VAR_MSG])
              aErrors.push(YamlError.new(sErr, @aPath))
            end
            aVarName.push(hData[TSR_VAR_MSG])
          end
        }
      end

      check_error(aErrors)
    end

    #=================================================================
    # ��  ��: ����ͤ��䴰����
    #=================================================================
    def complement_init_object_info()
      super()

      # mbxatr
      unless (is_specified?(TSR_PRM_MBXATR))
        @hState[TSR_PRM_ATR] = "ANY_ATT_MBX"
      end
      # maxmpri
      unless (is_specified?(TSR_PRM_MAXMPRI))
        @hState[TSR_PRM_MAXMPRI] = "MSG_PRI_MAX"
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
                  hVars[sTask][sVarName] = [TYP_T_P_MSG, TYP_T_P_MSG_PRI]
                end
              }
            end
          }
        }
      end

      return hVars  # [Hash]�Ԥ��������ꥹ������ѿ��ȷ����Ȥ߹�碌����
    end

    #=================================================================
    # ��  ��: ��å������ꥹ������ѿ��ȷ����Ȥ߹�碌�������֤�
    #=================================================================
    def get_msglist_variable()
      hVars = {}
      unless (@hState[TSR_PRM_MSGLIST].nil?())
        @hState[TSR_PRM_MSGLIST].each{|hData|
          unless (hData.nil?())
            hData.each{|sAtr, sVarName|
              if (sAtr == TSR_VAR_MSG)
                if (@hState[TSR_PRM_ATR] == KER_TA_MPRI)
                  hVars[sVarName] = [TYP_T_MSG_PRI]
                else
                  hVars[sVarName] = [TYP_T_MSG]
                end
              end
            }
          end
        }
      end

      return hVars  # [Hash]��å������ꥹ������ѿ��ȷ����Ȥ߹�碌����
    end
  end
end
