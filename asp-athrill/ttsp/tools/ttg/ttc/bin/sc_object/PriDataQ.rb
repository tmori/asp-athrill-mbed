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
#  $Id: PriDataQ.rb 9 2012-09-11 01:47:48Z nces-shigihara $
#
require "ttc/bin/sc_object/SCObject.rb"

#=====================================================================
# CommonModule
#=====================================================================
module CommonModule
  #===================================================================
  # ���饹̾: PriDataQ
  # ��    ��: ͥ���٥ǡ������塼�ξ����������륯�饹
  #===================================================================
  class PriDataQ < SCObject
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
        # stsklist
        sAtr = TSR_PRM_STSKLIST
        if (is_specified?(sAtr))
          cProc = Proc.new(){|hData, aPath|
            # ���ǤΥ����å�
            if (hData.is_a?(Hash))
              # ɬ�פ����Ǥ����ꤵ��Ƥ��뤫�����å�
              unless (hData.has_key?(TSR_VAR_DATA) && hData.has_key?(TSR_VAR_DATAPRI))
                sErr = sprintf(ERR_REQUIRED_KEY, "#{TSR_VAR_DATA} and #{TSR_VAR_DATAPRI}")
                raise(YamlError.new(sErr, aPath))
              else
                aProcErrors = []
                hData.each{|atr, val|
                  begin
                    case atr
                    when TSR_VAR_DATA
                      check_attribute_unsigned(atr, val, aPath)
                    when TSR_VAR_DATAPRI
                      check_attribute_range(atr, val, TTC_MAX_PRI, TTC_MIN_PRI, aPath)
                    else
                      sErr = sprintf(ERR_UNDEFINED_KEY, atr)
                      raise(YamlError.new(sErr, aPath))
                    end
                  rescue YamlError
                    aProcErrors.push($!)
                  end
                }
                check_error(aProcErrors)
              end
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

      begin
        # rtsklist
        sAtr = TSR_PRM_RTSKLIST
        if (is_specified?(sAtr))
          cProc = Proc.new(){|hData, aPath|
            if (hData.is_a?(Hash))
              aProcErrors = []
              hData.each{|atr, val|
                begin
                  case atr
                  when TSR_VAR_VARDATA, TSR_VAR_VARPRI
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
        # datalist
        sAtr = TSR_PRM_DATALIST
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
            # ɬ�פ����Ǥ����ꤵ��Ƥ��뤫�����å�
            unless (hData.has_key?(TSR_VAR_DATA) && hData.has_key?(TSR_VAR_DATAPRI))
              sErr = sprintf(ERR_REQUIRED_KEY, "#{TSR_VAR_DATA}\" and \"#{TSR_VAR_DATAPRI}")
              raise(YamlError.new(sErr, aPath + [nIndex]))
            end
            # ���Ǥ����ƥ����å�
            hData.each{|atr, val|
              begin
                case atr
                when TSR_VAR_DATA
                  check_attribute_unsigned(atr, val, aPath + [nIndex])
                when TSR_VAR_DATAPRI
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

      # datalist�Υ�����
      if (@hState[TSR_PRM_DATALIST].nil?())
        nDataCount = 0
      else
        nDataCount = @hState[TSR_PRM_DATALIST].size()
      end
      ### T3_PDQ001: �����ΰ�˶���������Τ������Ԥ�������������
      if (@hState[TSR_PRM_DATACNT] > nDataCount && !@hState[TSR_PRM_STSKLIST].nil?() && !@hState[TSR_PRM_STSKLIST].empty?())
        aErrors.push(YamlError.new("T3_PDQ001: " + ERR_SEND_WAITING_HAVE_SPACE, @aPath))
      end
      ### T3_PDQ002: �����ΰ�˥ǡ�������äƤ���Τ˼����Ԥ�������������
      if (nDataCount > 0 && !@hState[TSR_PRM_RTSKLIST].nil?() && !@hState[TSR_PRM_RTSKLIST].empty?())
        aErrors.push(YamlError.new("T3_PDQ002: " +ERR_RECV_WAITING_HAVE_DATA, @aPath))
      end
      ### T3_PDQ003: �����ΰ�ʾ�Υǡ�������äƤ���
      if (nDataCount > @hState[TSR_PRM_DATACNT])
        aErrors.push(YamlError.new("T3_PDQ003: " +ERR_DATALIST_HAVE_OVER_DATA, @aPath))
      end

      check_error(aErrors)
    end

    #=================================================================
    # ��  ��: ����ͤ��䴰����
    #=================================================================
    def complement_init_object_info()
      super()

      # pdqatr
      unless (is_specified?(TSR_PRM_PDQATR))
        @hState[TSR_PRM_ATR] = "ANY_ATT_PDQ"
      end
      # maxdpri
      unless (is_specified?(TSR_PRM_MAXDPRI))
        @hState[TSR_PRM_MAXDPRI] = "DATA_PRI_MAX"
      end
      # pdqcnt
      unless (is_specified?(TSR_PRM_PDQCNT))
        @hState[TSR_PRM_DATACNT] = "ANY_DATA_CNT"
      end
    end

    #=================================================================
    # ��  ��: �����Ԥ��������ꥹ������ѿ��ȷ����Ȥ߹�碌�������֤�
    #=================================================================
    def get_rtsklist_variable()
      hVars = {}
      unless (@hState[TSR_PRM_RTSKLIST].nil?())
        @hState[TSR_PRM_RTSKLIST].each{|hTask|
          hTask.each{|sTask, hData|
            unless (hData.nil?())
              hVars[sTask] = {}
              hData.each{|sAtr, sVarName|
                case sAtr
                when TSR_VAR_VARDATA
                  hVars[sTask][sVarName] = [TYP_INTPTR_T]
                when TSR_VAR_VARPRI
                  hVars[sTask][sVarName] = [TYP_PRI]
                end
              }
            end
          }
        }
      end

      return hVars  # [Hash]�����Ԥ��������ꥹ������ѿ��ȷ����Ȥ߹�碌����
    end
  end
end
