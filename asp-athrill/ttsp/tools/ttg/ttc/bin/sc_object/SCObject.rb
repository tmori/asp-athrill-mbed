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
#  $Id: SCObject.rb 9 2012-09-11 01:47:48Z nces-shigihara $
#
require "ttc/bin/sc_object/SCObject.rb"

#=====================================================================
# CommonModule
#=====================================================================
module CommonModule
  #===================================================================
  # ���饹̾: SCObject
  # ��    ��: Ʊ�����̿����֥������Ȥξ����������륯�饹
  #===================================================================
  class SCObject
    include TTCModule
    include TTCModule::ObjectCommon

    #=================================================================
    # ��  ��: °�������å�
    #=================================================================
    def attribute_check()
      aErrors = []
      @hState.each{|sAtr, val|
        begin
          sAtr = get_real_attribute_name(sAtr)
          if (is_specified?(sAtr))
            case sAtr
            # 0�ʾ������
            when TSR_PRM_DTQCNT, TSR_PRM_PDQCNT, TSR_PRM_MAXSEM, TSR_PRM_ISEMCNT, TSR_PRM_SEMCNT,
                 TSR_PRM_IFLGPTN, TSR_PRM_FLGPTN, TSR_PRM_BLKCNT, TSR_PRM_FBLKCNT, TSR_PRM_BLKSZ
              check_attribute_unsigned(sAtr, val, @aPath)

            # ʸ����
            when TSR_PRM_CLASS, TSR_PRM_MPF, TSR_PRM_PROCID
              check_attribute_type(sAtr, val, String, false, @aPath)

            # °��
            when TSR_PRM_SEMATR, TSR_PRM_FLGATR, TSR_PRM_DTQATR, TSR_PRM_PDQATR, TSR_PRM_MBXATR, TSR_PRM_MPFATR
              check_attribute_type(sAtr, val, String, false, @aPath)
              check_attribute_multi(sAtr, val, GRP_AVAILABLE_OBJATR[@sObjectType], @aPath)

            # ͥ����
            when TSR_PRM_MAXDPRI, TSR_PRM_MAXMPRI
              check_attribute_range(sAtr, val, TTC_MAX_PRI, TTC_MIN_PRI, @aPath)

            # spnstat
            when TSR_PRM_SPNSTAT
              check_attribute_type(sAtr, val, String, false, @aPath)
              check_attribute_enum(sAtr, val, GRP_ENUM_SPNSTAT, @aPath)

            # list
            when TSR_PRM_WTSKLIST, TSR_PRM_STSKLIST, TSR_PRM_RTSKLIST, TSR_PRM_DATALIST, TSR_PRM_MSGLIST
              # ���줾��Υ��饹�ǥ����å�����

            else
              abort(ERR_MSG % [__FILE__, __LINE__])
            end
          end
        rescue TTCError
          aErrors.push($!)
        end
      }

      check_error(aErrors)
    end

    #=================================================================
    # ��  ��: �������ꥹ�ȷϤ�°�������å�������
    #=================================================================
    def attribute_check_task_list(sAtr, aTaskList, cProc)
      check_class(String, sAtr)             # °��̾
      check_class(Object, aTaskList, true)  # �������ꥹ��
      check_class(Proc, cProc)              # ���Ǥ����ƥ����å�����

      check_attribute_type(sAtr, aTaskList, Array, false, @aPath)

      aErrors = []
      aPath   = @aPath + [sAtr]
      aTaskList.each_with_index{|hTask, nIndex|
        # �ꥹ�Ȥ����Ǥ�Hash��
        unless (hTask.is_a?(Hash))
          sErr = sprintf(ERR_LIST_INVALID_TYPE, sAtr, Hash, hTask.class())
          raise(YamlError.new(sErr, aPath + [nIndex]))
        end
        # ���Ǥ�Hash�Υ�������1��
        if (hTask.size() != 1)
          sErr = sprintf(ERR_LIST_MUST_BE_SINGLE, sAtr, hTask.size())
          raise(YamlError.new(sErr, aPath + [nIndex]))
        end
        # ���Ǥ����ƥ����å�
        hTask.each{|sTask, hVal|
          begin
            cProc.call(hVal, aPath + [nIndex, sTask])
          rescue YamlError
            aErrors.push($!)
          rescue TTCMultiError
            aErrors.concat($!.aErrors)
          end
        }
      }
      check_error(aErrors)
    end

    #=================================================================
    # ��  ��: ���֥������ȥ����å�
    #=================================================================
    def object_check(bIsPre = false)
      check_class(Bool, bIsPre)  # pre_condition��

      aErrors = []

      ### T3_SCO001: wtsklist��stsklist��rtsklist�Υ�����̾����ʣ���Ƥ���
      [TSR_PRM_WTSKLIST, TSR_PRM_STSKLIST, TSR_PRM_RTSKLIST].each{|sAtr|
        aTask = []
        unless (@hState[sAtr].nil?())
          @hState[sAtr].each{|hTask|
            hTask.each_key{|sTask|
              if (aTask.include?(sTask))
                sErr = sprintf("T3_SCO001: " + ERR_TASK_NAME_DUPLICATE, sTask)
                aErrors.push(YamlError.new(sErr, @aPath + [sAtr]))
              end
              aTask.push(sTask)
            }
          }
        end
      }

      check_error(aErrors)
    end

    #=================================================================
    # ��  ��: ����ͤ��䴰����
    #=================================================================
    def complement_init_object_info()
      # fmp����
      if (@cConf.is_fmp?())
        # class
        unless (is_specified?(TSR_PRM_CLASS))
            @hState[TSR_PRM_CLASS] = CFG_MCR_CLS_SELF_ALL
        end
      end
    end

    #=================================================================
    # ������: �䴰��¹Ԥ���
    #=================================================================
    def complement(cPrevObj)
      check_class(SCObject, cPrevObj)  # ľ���ξ��֤Υ��֥�������

      super(cPrevObj)
    end

    #=================================================================
    # ������: �����ꥢ����¹Ԥ���
    #=================================================================
    def alias(hAlias)
      check_class(Hash, hAlias)   # �����ꥢ���Ѵ��ơ��֥�

      super(hAlias)

      # stsklist
      unless (@hState[TSR_PRM_STSKLIST].nil?())
        aTmp = @hState[TSR_PRM_STSKLIST]
        @hState[TSR_PRM_STSKLIST] = []
        aTmp.each{|hTask|
          hTmp = hTask
          hTask = {}
          hTmp.each{|sTask, hData|
            hTask[hAlias[sTask]] = hData
          }
          @hState[TSR_PRM_STSKLIST].push(hTask)
        }
      end
      # rtsklist
      unless (@hState[TSR_PRM_RTSKLIST].nil?())
        aTmp = @hState[TSR_PRM_RTSKLIST]
        @hState[TSR_PRM_RTSKLIST] = []
        aTmp.each{|hTask|
          hTmp = hTask
          hTask = {}
          hTmp.each{|sTask, hData|
            unless (hData.nil?())
              hData.each{|atr, val|
                hData[atr] = alias_replace(val, hAlias)
              }
            end
            hTask[hAlias[sTask]] = hData
          }
          @hState[TSR_PRM_RTSKLIST].push(hTask)
        }
      end
      # wtsklist
      unless (@hState[TSR_PRM_WTSKLIST].nil?())
        aTmp = @hState[TSR_PRM_WTSKLIST]
        @hState[TSR_PRM_WTSKLIST] = []
        aTmp.each{|hTask|
          hTmp = hTask
          hTask = {}
          hTmp.each{|sTask, hData|
            unless (hData.nil?())
              hData.each{|atr, val|
                if (atr == TSR_VAR_VAR)
                  hData[atr] = alias_replace(val, hAlias)
                end
              }
            end
            hTask[hAlias[sTask]] = hData
          }
          @hState[TSR_PRM_WTSKLIST].push(hTask)
        }
      end
      # msglist
      unless (@hState[TSR_PRM_MSGLIST].nil?())
        @hState[TSR_PRM_MSGLIST].each{|hData|
          hData.each{|atr, val|
            if (atr == TSR_VAR_MSG)
              hData[atr] = alias_replace(val, hAlias)
            end
          }
        }
      end
    end

    #=================================================================
    # ������: ���֥������ȤΥ����ꥢ���Ѵ��ơ��֥���֤�
    #=================================================================
    def get_alias(sTestID, nNum = nil)
      check_class(String, sTestID)      # �ƥ���ID
      check_class(Integer, nNum, true)  # �����ֹ�

      hResult = {}

      # ���֥�������ID
      if (@sObjectType == TSR_OBJ_SPINLOCK)
        hResult[@sObjectID] = "#{TTG_LBL_SPINLOCK}_#{@hState[TSR_PRM_CLASS]}_#{nNum}"
      else
        hResult[@sObjectID] = alias_str(@sObjectID, sTestID)
      end

      # �ѿ�̾
      aVarNames = get_variable_names()
      aVarNames.each{|sVarName|
        hResult[sVarName] = alias_str(sVarName, sTestID)
      }

      return hResult  # [Hash]�����ꥢ���Ѵ��ơ��֥�
    end

    #=================================================================
    # ������: ���֥������Ȥ�ʣ�������֤�
    #=================================================================
    def dup()
      cObjectInfo = super()

      # ���֥�������IDʣ��
      cObjectInfo.sObjectID = safe_dup(@sObjectID)
      # ���֥������ȥ�����ʣ��
      cObjectInfo.sObjectType = safe_dup(@sObjectType)
      # �ѥ�᡼��ʣ��
      cObjectInfo.hState = safe_dup(@hState)

      return cObjectInfo  # [Object]ʣ���������֥�������
    end

    #=================================================================
    # ��  ��: �����Х��б��Τ���ѥ�᡼�����Ѵ���¹Ԥ���
    #=================================================================
    def convert_global(hTable, hClassTable)
      check_class(Hash, hTable)       # �Ѵ�ɽ
      check_class(Hash, hClassTable)  # ���饹�ִ��б�ɽ

      super(hTable, hClassTable)

      # rtsklist��stsklist��wtsklist
      [TSR_PRM_RTSKLIST, TSR_PRM_STSKLIST, TSR_PRM_WTSKLIST].each{|sAtr|
        unless (@hState[sAtr].nil?())
          @hState[sAtr].each{|hTask|
            hTask.each{|sTask, hData|
              unless (hData.nil?())
                hData.each{|atr, val|
                  hData[atr] = convert_global_params(val, hTable)
                }
              end
            }
          }
        end
      }

      # msglist��datalist
      [TSR_PRM_MSGLIST, TSR_PRM_DATALIST].each{|sAtr|
        unless (@hState[sAtr].nil?())
          @hState[sAtr].each{|hData|
            hData.each{|atr, val|
              hData[atr] = convert_global_params(val, hTable)
            }
          }
        end
      }
    end

    #=================================================================
    # ��  ��: ���֥����������¸�ߤ����ѿ�̾�������֤�
    #=================================================================
    def get_variable_names()
      aVarNames = []

      # rtsklist
      hVars = get_rtsklist_variable()
      hVars.each_value{|hVar|
        aVarNames.concat(hVar.keys())
      }

      # wtsklist
      hVars = get_wtsklist_variable()
      hVars.each_value{|hVar|
        aVarNames.concat(hVar.keys())
      }

      # msglist
      hVars = get_msglist_variable()
      aVarNames.concat(hVars.keys())

      return aVarNames.uniq().sort()  # [Array]���֥����������¸�ߤ����ѿ�̾����
    end

    #=================================================================
    # ��  ��: �����Ԥ��������ꥹ������ѿ��ȷ����Ȥ߹�碌�������֤�
    #=================================================================
    def get_rtsklist_variable()
      return {}  # [Hash]�����Ԥ��������ꥹ������ѿ��ȷ����Ȥ߹�碌����
    end

    #=================================================================
    # ��  ��: �Ԥ��������ꥹ������ѿ��ȷ����Ȥ߹�碌�������֤�
    #=================================================================
    def get_wtsklist_variable()
      return {}  # [Hash]�Ԥ��������ꥹ������ѿ��ȷ����Ȥ߹�碌����
    end

    #=================================================================
    # ��  ��: ��å������ꥹ������ѿ��ȷ����Ȥ߹�碌�������֤�
    #=================================================================
    def get_msglist_variable()
      return {}  # [Hash]��å������ꥹ������ѿ��ȷ����Ȥ߹�碌����
    end

    #=================================================================
    # ��  ��: �����ݻ���°��̾����TESRY��°��̾���������
    #=================================================================
    def get_real_attribute_name(sAtr)
      check_class(String, sAtr)  # �����ݻ���°��̾

      case sAtr
      when TSR_PRM_ATR
        sAtr = GRP_PRM_KEY_SC_ATR[@sObjectType]
      when TSR_PRM_DATACNT
        sAtr = GRP_PRM_KEY_SC_DATACNT[@sObjectType]
      end

      return sAtr  # [String]TESRY��°��̾
    end
  end
end
