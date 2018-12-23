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
#  $Id: TestScenario.rb 9 2012-09-11 01:47:48Z nces-shigihara $
#
require "ttc/bin/class/TTCCommon.rb"
require "common/bin/test_scenario/TestScenario.rb"

#=====================================================================
# CommonModule
#=====================================================================
module CommonModule
  #===================================================================
  # ���饹̾: TestScenario
  # ��    ��: PreCondition��Do��PostCondition�Υǡ������ݻ�
  #===================================================================
  class TestScenario
    include TTCModule

    #=================================================================
    # ������: ��¤�����å�
    #=================================================================
    def basic_check(sTestID, hScenario)
      check_class(Object, sTestID, true)    # �ƥ���ID
      check_class(Object, hScenario, true)  # �ƥ��ȥ��ʥꥪ

      aErrors = []
      ### T1_003: �ƥ���ID��ʸ��������
      unless (sTestID =~ TSR_REX_TEST_ID)
        sErr = sprintf("T1_003: " + ERR_INVALID_TESTID, sTestID)
        aErrors.push(YamlError.new(sErr))
      else
        ### T1_028: �ƥ���ID��ͽ��줬�Ȥ��Ƥ���
        if (sTestID =~ /^#{TTG_LBL_RESERVED}/i)
          sErr = sprintf("T1_028: " + ERR_INVALID_TESTID_PREFIX, sTestID)
          aErrors.push(YamlError.new(sErr))
        end
      end

      ### T1_004: �ƥ��ȥ��ʥꥪ��Hash�ǤϤʤ�
      unless (hScenario.is_a?(Hash))
        sErr = sprintf("T1_004: " + ERR_INVALID_TYPE_SCENARIO, Hash, hScenario.class())
        aErrors.push(YamlError.new(sErr))
      else
        aPath = [sTestID]

        # do��post_condition�Υ����å�
        bExistPre = false
        aSeqDo = []
        aSeqPost = []
        hScenario.each{|sCondition, shCondition|
          case sCondition
          # pre_condition
          when TSR_LBL_PRE
            bExistPre = true
            ### T1_007: pre_condition��Hash�ǤϤʤ�
            unless (shCondition.is_a?(Hash))
              sErr = sprintf("T1_007: " + ERR_INVALID_TYPE, TSR_LBL_PRE, Hash, shCondition.class())
              aErrors.push(YamlError.new(sErr, aPath + [sCondition]))
            end

          # do
          when TSR_REX_PRE_DO
            nSeqNum = $1.to_i()
            ### T1_009: do�Υ��������ֹ椬��Ť��������Ƥ���
            if (aSeqDo.include?(nSeqNum))
              sErr = sprintf("T1_009: " + ERR_CONDITION_MULTIPLE, TSR_LBL_DO, nSeqNum)
              aErrors.push(YamlError.new(sErr, aPath))
            end
            aSeqDo.push(nSeqNum)

            ### T1_010: do��Hash��nil�ǤϤʤ�
            unless (shCondition.nil?() || shCondition.is_a?(Hash))
              sErr = sprintf("T1_010: " + ERR_INVALID_TYPE_NIL, TSR_LBL_DO, Hash, shCondition.class())
              aErrors.push(YamlError.new(sErr, aPath + [sCondition]))
            end

            # ������ƥ��å�
            begin
              basic_check_timetick(sCondition, shCondition, aPath)
            rescue TTCMultiError
              aErrors.concat($!.aErrors)
            end

          # post_condition
          when TSR_REX_PRE_POST
            nSeqNum = $1.to_i()
            ### T1_011: post_condition�Υ��������ֹ椬��Ť��������Ƥ���
            if (aSeqPost.include?(nSeqNum))
              sErr = sprintf("T1_011: " + ERR_CONDITION_MULTIPLE, TSR_LBL_POST, nSeqNum)
              aErrors.push(YamlError.new(sErr, aPath))
            end
            aSeqPost.push(nSeqNum)

            ### T1_012: post_condition��Hash��nil�ǤϤʤ�
            unless (shCondition.nil?() || shCondition.is_a?(Hash))
              sErr = sprintf("T1_012: " + ERR_INVALID_TYPE_NIL, TSR_LBL_POST, Hash, shCondition.class())
              aErrors.push(YamlError.new(sErr, aPath + [sCondition]))
            end

            # ������ƥ��å�
            begin
              basic_check_timetick(sCondition, shCondition, aPath)
            rescue TTCMultiError
              aErrors.concat($!.aErrors)
            end

          # variation
          when TSR_LBL_VARIATION
            begin
              basic_check_variation(hScenario[TSR_LBL_VARIATION], aPath)
            rescue TTCMultiError
              aErrors.concat($!.aErrors)
            end

          # note
          when TSR_LBL_NOTE
            ### T1_027: note��ʸ����ǤϤʤ�
            unless (shCondition.is_a?(String))
              sErr = sprintf("T1_027: " + ERR_INVALID_TYPE, TSR_LBL_NOTE, String, shCondition.class())
              aErrors.push(YamlError.new(sErr, aPath + [sCondition]))
            end

          ### T1_005: �ƥ��ȥ��ʥꥪ�������ʥ��������ꤵ��Ƥ���
          else
            sErr = sprintf("T1_005: " + ERR_CONDITION_UNDEFINED, sCondition)
            aErrors.push(YamlError.new(sErr, aPath))
          end
        }

        ### T1_006: pre_condition��¸�ߤ��ʤ�
        if (bExistPre == false)
          sErr = sprintf("T1_006: " + ERR_CONDITION_NOT_EXIST, TSR_LBL_PRE)
          aErrors.push(YamlError.new(sErr, aPath))
        end
        ### T1_008: do��¸�ߤ��ʤ�
        if (aSeqDo.empty?())
          sErr = sprintf("T1_008: " + ERR_CONDITION_NOT_EXIST, TSR_LBL_DO)
          aErrors.push(YamlError.new(sErr, aPath))
        else
          ### T1_013: do��post_condition�Υ��������ֹ椬�б����Ƥ��ʤ�
          if (aSeqDo.uniq.sort() != aSeqPost.uniq.sort())
            aErrors.push(YamlError.new("T1_013: " + ERR_CONDITION_NOT_MATCH, aPath))
          end
        end
      end

      check_error(aErrors)
    end

    #=================================================================
    # ������: �Хꥨ�����������ι�¤�����å�
    #=================================================================
    def basic_check_variation(hVariation, aPath)
      check_class(Object, hVariation, true)  # �Хꥨ�������
      check_class(Array, aPath)            # �롼�Ȥ���Υѥ�

      aErrors = []
      ### T1_021: variation��Hash��nil�ǤϤʤ�
      unless (hVariation.nil?() || hVariation.is_a?(Hash))
        sErr = sprintf("T1_021: " + ERR_INVALID_TYPE_NIL, TSR_LBL_VARIATION, Hash, hVariation.class())
        aErrors.push(YamlError.new(sErr))
      end

      # �ѥ�᡼��
      if (hVariation.is_a?(Hash))
        aNewPath = aPath + [TSR_LBL_VARIATION]
        hVariation.each{|sAtr, val|
          case sAtr
          # ������
          when TSR_PRM_GAIN_TIME, TSR_PRM_ENA_EXC_LOCK, TSR_PRM_GCOV_ALL, TSR_PRN_ENA_CHGIPM,
               TSR_PRM_SUPPORT_GET_UTM, TSR_PRM_SUPPORT_ENA_INT, TSR_PRM_SUPPORT_DIS_INT
            unless (Bool.include?(val.class()))
              sErr = sprintf(ERR_VARIATION_INVALID_TYPE, sAtr, "Bool", val.class())
              aErrors.push(YamlError.new(sErr, aNewPath))
            end

          # �����ޥ������ƥ�����
          when TSR_PRM_TIMER_ARCH
            if (val != TSR_PRM_TIMER_GLOBAL && val != TSR_PRM_TIMER_LOCAL)
              sErr = sprintf(ERR_VARIATION_INVALID_VALUE, sAtr, val)
              aErrors.push(YamlError.new(sErr, aNewPath))
            end

          # IRC�������ƥ�����
          when TSR_PRM_IRC_ARCH
            if (val != TSR_PRM_IRC_GLOBAL && val != TSR_PRM_IRC_LOCAL && val != TSR_PRM_IRC_COMBINATION)
              sErr = sprintf(ERR_VARIATION_INVALID_VALUE, sAtr, val)
              aErrors.push(YamlError.new(sErr, aNewPath))
            end

          # ̤����Υ���
          else
            sErr = sprintf(ERR_VARIATION_UNDEFINED_KEY, sAtr)
            aErrors.push(YamlError.new(sErr, aNewPath))
          end
        }
      end

      check_error(aErrors)
    end
    private :basic_check_variation

    #=================================================================
    # ������: ������ƥ��å������å�
    #=================================================================
    def basic_check_timetick(sCondition, hCondition, aPath)
      check_class(String, sCondition)        # ����ǥ������̾
      check_class(Object, hCondition, true)  # ����ǥ������
      check_class(Array, aPath)              # �롼�Ȥ���Υѥ�

      aErrors = []
      hMacro = @cConf.get_macro()
      if (has_timetick?(hCondition))
        hCondition.each_key{|nTimeTick|
          ### T1_014: ������ƥ��å����꤬0��꾮����
          if (parse_value(nTimeTick, hMacro) < 0)
            sErr = sprintf("T1_014: " + ERR_INVALID_TIMETICK, nTimeTick)
            aErrors.push(YamlError.new(sErr, aPath))
          end
        }
      end

      check_error(aErrors)
    end
    private :basic_check_timetick

    #=================================================================
    # ��  ��: °�������å�
    #=================================================================
    def attribute_check()
      aErrors = []
      aCondition = get_all_condition()
      aCondition.each{|cCondition|
        begin
          cCondition.attribute_check()
        rescue TTCMultiError
          aErrors.concat($!.aErrors)
        end
      }
      check_error(aErrors)
    end

    #=================================================================
    # ��  ��: ���֥������ȥ����å�
    #=================================================================
    def object_check()
      aErrors = []
      begin
        @cPreCondition.object_check(true)
      rescue TTCMultiError
        aErrors.concat($!.aErrors)
      end
      @aDo_PostCondition.each{|cCondition|
        begin
          cCondition.object_check()
        rescue TTCMultiError
          aErrors.concat($!.aErrors)
        end
      }
      check_error(aErrors)
    end

    #=================================================================
    # ��  ��: ����ǥ����������å�
    #=================================================================
    def condition_check()
      aErrors = []
      aCondition = get_all_condition()
      aCondition.each{|cCondition|
        begin
          cCondition.condition_check()
        rescue TTCMultiError
          aErrors.concat($!.aErrors)
        end
      }
      check_error(aErrors)
    end

    #=================================================================
    # ��  ��: ���ʥꥪ�����å�
    #=================================================================
    def scenario_check()
      aErrors = []

      aPreVarNames   = @cPreCondition.get_variable_names()
      cPrevCondition = @cPreCondition
      @aDo_PostCondition.each_with_index{|cCondition, nIndex|
        # do�Υ����å�
        aPath = cCondition.get_do_path()
        # id
        sCallerObject = cCondition.hDo[TSR_PRM_ID]
        unless (sCallerObject.nil?())
          if (cPrevCondition.hAllObject.has_key?(sCallerObject))
            cPrevCaller      = cPrevCondition.hAllObject[sCallerObject]
            nPrcid           = cPrevCondition.get_process_prcid(cPrevCaller)
            aActivateProcess = cPrevCondition.get_activate_process_unit_by_prcid()
            if (GRP_PROCESS_UNIT_ALL.include?(cPrevCaller.sObjectType))
              # API��ȯ�ԤǤ������ñ�̤������å�
              if (cPrevCaller != aActivateProcess[nPrcid])
                ### T5_F001: ���������֤�running-suspended�λ����󥿥������¹Ծ��֤ʤ��do��api��ȯ�Ԥ��Ƥ���ΤϤ����󥿥�����
                if (cPrevCaller.sObjectType == TSR_OBJ_TASK && cPrevCaller.is_running_suspended?())
                  sErr = sprintf("T5_F001: " + ERR_DO_ID_MISMATCH_RUS_TASK, aActivateProcess[nPrcid].sObjectID)
                ### T5_005: do��API��ȯ�Ԥ��륪�֥������Ȥ�Ʊ�쥿����ƥ��å����ľ���ξ��֤Ǽ¹Ծ��֤Ǥʤ�
                else
                  sErr = sprintf("T5_005: " + ERR_OBJECT_NOT_ACTIVATE_PREV, sCallerObject)
                end
                aErrors.push(YamlError.new(sErr, aPath + [TSR_PRM_ID]))
              end

            ### T5_004: do��API��ȯ�Ԥ��륪�֥������Ȥ�����ñ�̤Ǥʤ�
            else
              sErr = sprintf("T5_004: " + ERR_TARGET_NOT_PROCESS_UNIT, sCallerObject)
              aErrors.push(YamlError.new(sErr, aPath + [TSR_PRM_ID]))
            end
          ### T5_003: do��API��ȯ�Ԥ��륪�֥������Ȥ�¸�ߤ��ʤ�
          else
            sErr = sprintf("T5_003: " + ERR_OBJECT_NOT_DEFINED_IN_PRE, sCallerObject)
            aErrors.push(YamlError.new(sErr, aPath + [TSR_PRM_ID]))
          end
        end

        # post_condition�Υ����å�
        # �ѿ�����Υ����å�
        aNotDefined = cCondition.get_variable_names() - aPreVarNames
        ### T5_002: post_condition��pre_condition���������Ƥ��ʤ��ѿ���¸�ߤ���
        unless (aNotDefined.empty?())
          sErr  = sprintf("T5_002: " + ERR_VAR_NOT_DEFINED_IN_PRE, aNotDefined.join(", "))
          aPath = cCondition.get_condition_path()
          aErrors.push(YamlError.new(sErr, aPath))
        end

        # ľ���Υ���ǥ������Ȥδط������å�
        if (cPrevCondition != @cPreCondition)
          aPath = [@sTestID]
          # ���ֻ���Υ����å�
          if (cPrevCondition.nTimeTick > cCondition.nTimeTick)
            ### T5_006: ������ƥ��å�����ǲ������
            sErr = sprintf("T5_006: " + ERR_TIME_RETURN, cPrevCondition.nTimeTick, cCondition.nTimeTick)
            aErrors.push(YamlError.new(sErr, aPath))
          elsif (cPrevCondition.nTimeTick != cCondition.nTimeTick)
            ### T5_008: CPU��å����֤ǻ��֤��ʤ�
            if (cPrevCondition.exist_cpulock?())
              sErr = sprintf("T5_008: " + ERR_TIME_PROGRESS_IN_CPU_LOCK, cPrevCondition.nTimeTick, cCondition.nTimeTick)
              aErrors.push(YamlError.new(sErr, aPath))
            end
=begin
            ### T5_009: CPU���֤�chg_ipm!=0 �ξ��֤ǻ��֤��ʤ�
            if (cPrevCondition.exist_disable_interrupt?())
              sErr = sprintf("T5_009: " + ERR_TIME_PROGRESS_CHG_IPM, cPrevCondition.nTimeTick, cCondition.nTimeTick)
              aErrors.push(YamlError.new(sErr, aPath))
            end
=end
            ### T5_010: �󥿥����¹���˻��֤��в᤹��
            if (exist_keep_activate_non_context?(cPrevCondition, cCondition))
              sErr = sprintf("T5_010: " + ERR_TIME_PROGRESS_NON_CONTEXT, cPrevCondition.nTimeTick, cCondition.nTimeTick)
              aErrors.push(YamlError.new(sErr, aPath))
            end
          end
        end

        # ���顼�����ɻ���
        begin
          unless (cCondition.exist_error_code?())
            scenario_check_require_ercd(nIndex)
          else
            scenario_check_cannot_check_ercd(nIndex)
          end
        rescue YamlError
          aErrors.push($!)
        end

        # ľ���Υ���ǥ������
        cPrevCondition = cCondition
      }


      # FMP����
      if (@cConf.is_fmp?())
        # running-waitspin
        aCondition = [@cPreCondition, @aDo_PostCondition.last()]
        aCondition.each{|cCondition|
          hObjects = cCondition.get_objects_by_type(TSR_OBJ_TASK)
          hObjects.each{|sObjectID, cObjectInfo|
            ### T5_F003: pre_condition����ӺǸ��post_condition��¸�ߤ��륿�����ξ��֤�running-waitspin�ˤʤäƤ���
            if (cObjectInfo.is_spinlock_waiting?())
              sErr = sprintf("T5_F003: " + ERR_CANNOT_BE_RUNNING_WAITSPIN, sObjectID)
              aPath = cCondition.get_condition_path() + [sObjectID, TSR_PRM_TSKSTAT]
              aErrors.push(YamlError.new(sErr, aPath))
            end
          }
        }
        # �����Х륿����
        if (!@cConf.is_timer_local?() && @hVariation[TSR_PRM_TIMER_ARCH] != TSR_PRM_TIMER_LOCAL)
          aPrcid = []
          aCondition = get_all_condition()
          aCondition.each{|cCondition|
            hObjects = cCondition.get_objects_by_type(GRP_TIME_EVENT_HDL)
            hObjects.each_value{|cObjectInfo|
              aPrcid.push(cObjectInfo.hState[TSR_PRM_PRCID])
            }
          }
          ### T5_F004: �����Х륿���޻�����������।�٥�ȥϥ�ɥ餬ʣ���Υץ��å����������Ƥ���
          if (aPrcid.uniq().size() > 1)
            aErrors.push(YamlError.new("T5_F004: " + ERR_TIMEEVENT_PRCID_GLOBAL, [@sTestID]))
          end
        end
      end

      check_error(aErrors)
    end

    #=================================================================
    # ������: ���顼�����ɻ���ϳ������å�
    #=================================================================
    def scenario_check_require_ercd(nIndex)
      check_class(Integer, nIndex)  # �����ܤ�do��post��

      cCondition      = @aDo_PostCondition[nIndex]
      aCondition      = get_all_condition()
      cPrevCondition  = aCondition[nIndex]
      aAfterCondition = aCondition.slice(nIndex + 1, aCondition.size())
      sCallerObject   = cCondition.hDo[TSR_PRM_ID]
      aPath           = cCondition.get_do_path()
      ### T5_012: ���顼�����ɤ����ꤵ��Ƥ��ʤ�
      unless (cCondition.hDo[TSR_PRM_SYSCALL].nil?())
        # ��³�Υ���ǥ����������å�
        aAfterCondition.each{|cTargetCondition|
          cObjectInfo = cTargetCondition.hAllObject[sCallerObject]
          aActivate   = cTargetCondition.get_activate_by_prcid()
          nPrcid      = cTargetCondition.get_process_prcid(cObjectInfo)
          # ��ư���Ƥ��뤫
          if (!nPrcid.nil?() && !cObjectInfo.nil?() && GRP_PROCESS_UNIT_ALL.include?(cObjectInfo.sObjectType) &&
              ((aActivate[nPrcid].nil?() && cObjectInfo.is_activate?()) || aActivate[nPrcid] == cObjectInfo)
             )
            # �������ξ��
            if (cObjectInfo.sObjectType == TSR_OBJ_TASK)
              cPrevObject = cPrevCondition.hAllObject[sCallerObject]
              cTex        = cTargetCondition.get_task_exc_by_task(sCallerObject)
              unless ((!cTex.nil?() && cTex.is_activate?()) || (cPrevObject.hState[TSR_PRM_BOOTCNT] < cObjectInfo.hState[TSR_PRM_BOOTCNT]))
                sErr = sprintf("T5_012: " + ERR_NOT_DEFINED_ERROR_CODE, sCallerObject)
                raise(YamlError.new(sErr, aPath))
              end
            else
              sErr = sprintf("T5_012: " + ERR_NOT_DEFINED_ERROR_CODE, sCallerObject)
              raise(YamlError.new(sErr, aPath))
            end
          end
          cPrevCondition = cTargetCondition
        }
      end
    end

    #=================================================================
    # ������: ���顼�����ɳ�ǧ��ǽ�����å�
    #=================================================================
    def scenario_check_cannot_check_ercd(nIndex)
      check_class(Integer, nIndex)  # �����ܤ�do��post��

      cCondition      = @aDo_PostCondition[nIndex]
      aCondition      = get_all_condition()
      cPrevCondition  = aCondition[nIndex]
      aAfterCondition = aCondition.slice(nIndex + 1, aCondition.size())
      sCallerObject   = cCondition.hDo[TSR_PRM_ID]
      # ��³�Υ���ǥ����������å�
      bActivate = false
      aAfterCondition.each{|cTargetCondition|
        cObjectInfo = cTargetCondition.hAllObject[sCallerObject]
        unless (cObjectInfo.nil?())
          aActivate   = cTargetCondition.get_activate_by_prcid()
          nPrcid      = cTargetCondition.get_process_prcid(cObjectInfo)
          # ��ư���Ƥ��뤫
          if ((aActivate[nPrcid].nil?() && cObjectInfo.is_activate?()) || aActivate[nPrcid] == cObjectInfo)
            # �������ξ��
            if (cObjectInfo.sObjectType == TSR_OBJ_TASK)
              cPrevObject = cPrevCondition.hAllObject[sCallerObject]
              cTex        = cTargetCondition.get_task_exc_by_task(sCallerObject)
              unless ((!cTex.nil?() && cTex.is_activate?()) || (cPrevObject.hState[TSR_PRM_BOOTCNT] < cObjectInfo.hState[TSR_PRM_BOOTCNT]))
                bActivate = true
                break
              end
            else
              bActivate = true
              break
            end
          end
        end
        cPrevCondition = cTargetCondition
      }
      ### T5_013: ���顼�����ɤ���ǧ�Ǥ��ʤ�
      if (bActivate == false)
        sErr = sprintf("T5_013: " + ERR_CANNNOT_CHECK_ERROR_CODE, sCallerObject)
        raise(YamlError.new(sErr, cCondition.get_do_path()))
      end
    end

    #=================================================================
    # ��  ��: ���ʥꥪ�����å�(�ޥ�����ʬ�Τ�)
    #=================================================================
    def scenario_check_macro()
      aMacro = get_all_prcid()
      ### T5_F002: prcid�˻��ꤹ��ޥ���PRC_OTHER��PRC_OTHER_1��PRC_OTHER_2�Τ����줫��Ʊ���˻��ꤵ��Ƥ���
      if (aMacro.include?(CFG_MCR_PRC_OTHER) && (aMacro.include?(CFG_MCR_PRC_OTHER_1) || aMacro.include?(CFG_MCR_PRC_OTHER_2)))
        aMacro.delete(CFG_MCR_PRC_SELF)
        aMacro = aMacro.reject(){|val|
          !(val =~ /^PRC_/)
        }
        aMacro = aMacro.uniq().sort()
        sErr = sprintf("T5_F002: " + ERR_PRCID_MACRO_COMBINATION, aMacro.join(", "))
        raise(YamlError.new(sErr, [@sTestID]))
      end
    end

    #=================================================================
    # ������: ���ƤΥޥ�����ִ�����
    #=================================================================
    def convert_macro()
      aCondition = get_all_condition()
      aCondition.each{|cCondition|
        cCondition.convert_macro()
      }
    end

    #=================================================================
    # ������: ���Ƥ�post_condition���䴰��¹Ԥ���
    #=================================================================
    def complement()
      # �ǥե�������䴰
      @cPreCondition.complement_init_object_info()
      # ľ���ξ��֤����䴰
      cPrevCondition = @cPreCondition
      @aDo_PostCondition.each{|cCondition|
        cCondition.complement(cPrevCondition)
        cPrevCondition = cCondition
      }
      # �����
      @cPreCondition.complement_after()
      cPrevCondition = @cPreCondition
      @aDo_PostCondition.each{|cCondition|
        cCondition.complement_after()
      }
    end

    #=================================================================
    # ������: �����ꥢ����¹Ԥ���
    #=================================================================
    def alias()
      hAlias = @cPreCondition.get_alias()
      aCondition = get_all_condition()
      aCondition.each{|cCondition|
        cCondition.alias(hAlias)
      }
    end

    #=================================================================
    # ��  ��: �ƥ��ȥ��ʥꥪ�����Ƥ�YAML���֥������Ȥ��Ѵ������֤�
    #=================================================================
    def to_yaml()
      hYaml = {}
      hYaml[@sTestID] = Hash.new{|hash, key|
        hash[key] = {}
      }
      # pre_condition
      hYaml[@sTestID][TSR_LBL_PRE] = @cPreCondition.to_yaml(true)
      # do��post_condition
      @aDo_PostCondition.each{|cCondition|
        nTimeTick = cCondition.nTimeTick
        sDoSeq    = "#{TSR_UNS_DO}#{cCondition.nSeqNum}"
        sPostSeq  = "#{TSR_UNS_POST}#{cCondition.nSeqNum}"
        hYaml[@sTestID][sDoSeq][nTimeTick]   = cCondition.hDo
        hYaml[@sTestID][sPostSeq][nTimeTick] = cCondition.to_yaml()
      }
      return safe_dup(hYaml)  # [Hash]YAML���֥�������
    end

    #=================================================================
    # ������: �Хꥨ�����������å�
    #=================================================================
    def variation_check()
      aErrors = []

      # ��������
      begin
        @bGainTime = is_gain_time_mode?()
      rescue TTCExcludeError
        aErrors.push($!)
      end

      ### T6_002: �����ȯ���ؿ���ɬ�פʤΤ˻����Բ�
      if (@cConf.get_func_interrupt() == false && exist_interrupt_handler?())
        sErr = sprintf("T6_002: " + ERR_VARIATION_NO_FUNC, CFG_FUNC_INTERRUPT)
        aErrors.push(TTCExcludeError.new(sErr, :T6_002))
      end
      ### T6_003: CPU�㳰ȯ���ؿ���ɬ�פʤΤ˻����Բ�
      if (@cConf.get_func_exception() == false && exist_cpu_exception?())
        sErr = sprintf("T6_003: " + ERR_VARIATION_NO_FUNC, CFG_FUNC_EXCEPTION)
        aErrors.push(TTCExcludeError.new(sErr, :T6_003))
      end

      ### T6_004: CPU��å����CPU�㳰ȯ���Υ��ݡ��Ȥ�����Ƥ��ʤ�
      if (@cConf.get_enable_exc_in_cpulock() == false && @hVariation[TSR_PRM_ENA_EXC_LOCK] == true)
        aErrors.push(TTCExcludeError.new("T6_004: " + ERR_VARIATION_EXCEPT_IN_CPULOCK, :T6_004))
      end

      ### T6_005: �󥿥�������ƥ����Ȥ���γ����ͥ���٥ޥ����ѹ����ݡ��Ȥ�����Ƥ��ʤ�
      if (@cConf.get_enable_chg_ipm_in_non_task() == false && @hVariation[TSR_PRN_ENA_CHGIPM] == true)
        aErrors.push(TTCExcludeError.new("T6_005: " + ERR_VARIATION_CHGIPM_IN_NONTASK, :T6_005))
      end

      ### T6_006: API��get_utm�����ݡ��Ȥ���Ƥ��ʤ�
      if (@cConf.get_api_support_get_utm() == false && @hVariation[TSR_PRM_SUPPORT_GET_UTM] == true)
        aErrors.push(TTCExcludeError.new("T6_006: " + ERR_VARIATION_NOT_SUPPORT_GET_UTM, :T6_006))
      end

      ### T6_007: API��ena_int�����ݡ��Ȥ���Ƥ��ʤ�
      if (@cConf.get_api_support_ena_int() == false && @hVariation[TSR_PRM_SUPPORT_ENA_INT] == true)
        aErrors.push(TTCExcludeError.new("T6_007: " + ERR_VARIATION_NOT_SUPPORT_ENA_INT, :T6_007))
      end

      ### T6_008: API��dis_int�����ݡ��Ȥ���Ƥ��ʤ�
      if (@cConf.get_api_support_dis_int() == false && @hVariation[TSR_PRM_SUPPORT_DIS_INT] == true)
        aErrors.push(TTCExcludeError.new("T6_008: " + ERR_VARIATION_NOT_SUPPORT_DIS_INT, :T6_008))
      end

=begin
      ### T6_009: ���ꤷ��������ֹ�ο�����¿��������ֹ椬���Ѥ���Ƥ���
      aAllIntno = get_all_intno()
      if (aAllIntno.size() > @cConf.get_intno_num())
        sErr = sprintf("T6_009: " + ERR_VARIATION_OVER_INTNO_NUM, @cConf.get_intno_num(), aAllIntno.size())
        raise(TTCError.new(sErr))
      end
=end

      ### T6_010: ena_int��dis_int�Τ����줫�����ݡ��Ȥ���Ƥ��ʤ����˳���ߥϥ�ɥ顦����ߥ����ӥ��롼����ξ��֤��Ѳ�����
      if (@cConf.get_api_support_ena_int() == false || @cConf.get_api_support_dis_int() == false)
        bOnError = false
        aCondition = get_all_condition()
        aCondition.each{|cCondition|
          hObjects = cCondition.get_objects_by_type([TSR_OBJ_INTHDR, TSR_OBJ_ISR])
          hObjects.each{|sObjectID, cObjectInfo|
            unless (cObjectInfo.is_initial_status?())
              aErrors.push(TTCExcludeError.new("T6_010: " + ERR_VARIATION_STATUS_INVALID, :T6_010))
              bOnError = true
              break
            end
          }
          # ���˥��顼�����ꤷ�Ƥ���ʤ�ȴ����
          if (bOnError == true)
            break
          end
        }
      end

      # fmp
      if (@cConf.is_fmp?())
        # �ץ��å����Υ����å�
        nMax = @cConf.get_prc_num()
        nProc = get_max_prcid()
        ### T6_F001: ���ꤷ���ץ��å������¿���ץ��å������Ѥ���Ƥ���
        if (nMax != 0 && nProc > nMax)
          sErr = sprintf("T6_F001: " + ERR_VARIATION_OVER_PRC_NUM, nMax, nProc)
          aErrors.push(TTCExcludeError.new(sErr, :T6_F001))
        end

        # ���ԥ��å����Υ����å�
        nMax = @cConf.get_spinlock_num()
        nSpinlock = get_spinlock_count()
        ### T6_F002: ���ꤷ�����ԥ��å������¿�����ԥ��å������Ѥ���Ƥ���
        if (!nMax.nil?() && nMax != 0 && nSpinlock > nMax)
          sErr = sprintf("T6_F002: " + ERR_VARIATION_OVER_SPINLOCK_NUM, nMax, nSpinlock)
          raise(TTCError.new(sErr))
        end

        ### T6_F003: ���ץ��å�����ߤ�ȯ���������ʤ��Τ�pre_condition�ǲ��Ͼ��֤Υ��������о줹��
        if (@cConf.get_own_ipi_raise() == false && exist_rus_task?())
          aErrors.push(TTCExcludeError.new("T6_F003: " + ERR_VARIATION_CANNOT_OWN_IPI, :T6_F003))
        end

        ### T6_F004: IRC�������ƥ����㤬configure�ǻ��ꤵ�줿�����Ȱۤʤ�
        if (!@hVariation[TSR_PRM_IRC_ARCH].nil?() && @hVariation[TSR_PRM_IRC_ARCH] != @cConf.get_irc_arch())
          sErr = sprintf("T6_F004: " + ERR_VARIATION_NOT_MATCH_IRC_ARCH, @cConf.get_irc_arch(), @hVariation[TSR_PRM_IRC_ARCH])
          aErrors.push(TTCExcludeError.new(sErr, "T6_F004_#{@hVariation[TSR_PRM_IRC_ARCH]}".to_sym()))
        end

        ### T6_F005: �����ޡ��������ƥ����㤬configure�ǻ��ꤵ�줿�����Ȱۤʤ�
        if (!@hVariation[TSR_PRM_TIMER_ARCH].nil?() && @hVariation[TSR_PRM_TIMER_ARCH] != @cConf.get_timer_arch())
          sErr = sprintf("T6_F005: " + ERR_VARIATION_NOT_MATCH_TIMER_ARCH, @cConf.get_timer_arch(), @hVariation[TSR_PRM_TIMER_ARCH])
          aErrors.push(TTCExcludeError.new(sErr, :T6_F005))
        end
      end

      # ���顼�����ä����
      unless (aErrors.empty?())
        raise(TTCMultiExcludeError.new(aErrors))
      end
    end

    #=================================================================
    # ��  ��: ����ǥ���������¸�ߤ���ץ��å��ֹ�κ����ͤ��֤�
    #=================================================================
    def get_max_prcid()
      nMaxPrcid = 0
      aPrcid = get_all_prcid()
      aPrcid = aPrcid.reject(){|val|
        !val.is_a?(Integer)
      }
      unless (aPrcid.empty?())
        nMaxPrcid = aPrcid.max()
      end

      return nMaxPrcid  # [Integer]����ǥ���������¸�ߤ���ץ��å��ֹ�κ�����
    end

    #=================================================================
    # ��  ��: �ƥ��ȥ��ʥꥪ���¸�ߤ������ƤΥץ��å��ֹ���֤�
    #=================================================================
    def get_all_prcid()
      aPrcid = []
      # ���ƤΥ���ǥ������ν���ñ�̤�prcid���������
      aCondition = get_all_condition()
      aCondition.each{|cCondition|
        aPrcid.concat(cCondition.get_all_prcid())
      }

      return aPrcid  # [Array]�ƥ��ȥ��ʥꥪ���¸�ߤ������ƤΥץ��å��ֹ�
    end

    #=================================================================
    # ��  ��: �ƥ��ȥ��ʥꥪ���¸�ߤ��륹�ԥ��å������֤�
    #=================================================================
    def get_spinlock_count()
      aSpinID = get_spinlock_names()

      return aSpinID.size()  # [Integer]�ƥ��ȥ��ʥꥪ���¸�ߤ��륹�ԥ��å���
    end

    #=================================================================
    # ��  ��: �ƥ��ȥ��ʥꥪ���¸�ߤ��륹�ԥ��å�ID���֤�
    #=================================================================
    def get_spinlock_names()
      hSpinlock = @cPreCondition.get_objects_by_type(TSR_OBJ_SPINLOCK)

      return hSpinlock.keys()  # [Array]�ƥ��ȥ��ʥꥪ���¸�ߤ��륹�ԥ��å�ID
    end

    #=================================================================
    # ��  ��: ����ߥϥ�ɥ�ǳ�����ֹ椴�Ȥ˥����å�����°�����֤�
    #=================================================================
    def get_inthdr_attributes_by_intno()
      return @cPreCondition.get_inthdr_attributes_by_intno()  # [Hash]������ֹ椴�Ȥγ���°��
    end

    #=================================================================
    # ��  ��: ����ߥ����ӥ��롼����ǳ�����ֹ椴�Ȥ˥����å�����°��
    #       : ���֤�
    #=================================================================
    def get_isr_attributes_by_intno()
      return @cPreCondition.get_isr_attributes_by_intno()  # [Hash]������ֹ椴�Ȥγ���°��
    end

    #=================================================================
    # ��  ��: ����ߥ����ӥ��롼����ǳ�����ֹ�ȳ����ͥ���٤��Ȥ߹�
    #       : �碌���Ȥ˥����å�����°�����֤�
    #=================================================================
    def get_isr_attributes_by_intno_and_isrpri()
      return @cPreCondition.get_isr_attributes_by_intno_and_isrpri()  # [Hash]������ֹ�ȳ����ͥ���٤��Ȥ߹�碌���Ȥγ���°��
    end

    #=================================================================
    # ��  ��: CPU�㳰�ϥ�ɥ��CPU�㳰�ϥ�ɥ��ֹ椴�Ȥ˥����å�����°
    #       : �����֤�
    #=================================================================
    def get_exception_attributes_by_excno()
      return @cPreCondition.get_exception_attributes_by_excno()  # [Hash]CPU�㳰�ϥ�ɥ��ֹ椴�Ȥγ���°��
    end

    #=================================================================
    # ��  ��: ����ߥϥ�ɥ餬¸�ߤ��뤫���֤�
    #=================================================================
    def exist_interrupt_handler?()
      hIntHdr = @cPreCondition.get_objects_by_type([TSR_OBJ_INTHDR, TSR_OBJ_ISR])

      return !(hIntHdr.empty?())  # [Bool]����ߥϥ�ɥ餬¸�ߤ��뤫
    end
    private :exist_interrupt_handler?

    #=================================================================
    # ��  ��: CPU�㳰��¸�ߤ��뤫���֤�
    #=================================================================
    def exist_cpu_exception?()
      hCpuExc = @cPreCondition.get_objects_by_type(TSR_OBJ_EXCEPTION)

      return !(hCpuExc.empty?())  # [Bool]CPU�㳰��¸�ߤ��뤫
    end
    private :exist_cpu_exception?

    #=================================================================
    # ��  ��: ���Ͼ��֤Υ�������pre_condition��¸�ߤ��뤫���֤�
    #=================================================================
    def exist_rus_task?()
      bResult = false
      @cPreCondition.hAllObject.each{|sObjectID, cObjectInfo|
        if (cObjectInfo.sObjectType == TSR_OBJ_TASK && cObjectInfo.hState[TSR_PRM_STATE] == KER_TTS_RUS)
          bResult = true
          break
        end
      }

      return bResult  # [Bool]���Ͼ��֤Υ�������pre_condition��¸�ߤ��뤫
    end
    private :exist_rus_task?

    #=================================================================
    # ��  ��: ����ǥ������֤Ǽ¹Ծ��֤Τޤޤ��󥿥��������뤫���֤�
    #=================================================================
    def exist_keep_activate_non_context?(cPrevCondition, cCondition)
      check_class(Condition, cPrevCondition)  # ľ���Υ���ǥ������
      check_class(Condition, cCondition)      # ���Ȥʤ륳��ǥ������

      bResult = false
      # ľ���Υ���ǥ������μ¹Ծ��֤��󥿥�������
      hPrevActivate = {}
      hObjects = cPrevCondition.get_objects_by_type(GRP_NON_CONTEXT)
      hObjects.each{|sObjectID, cObjectInfo|
        if (cObjectInfo.is_activate?())
          hPrevActivate[sObjectID] = cObjectInfo
        end
      }
      # ���Ȥʤ륳��ǥ��������󥿥�����ư�³���Ƥ��뤫
      hObjects = cCondition.get_objects_by_type(GRP_NON_CONTEXT)
      hObjects.each{|sObjectID, cObjectInfo|
        # bootcnt���Ѳ����Ƥ��ʤ�
        if (hPrevActivate.has_key?(sObjectID) && cObjectInfo.is_activate?() &&
            hPrevActivate[sObjectID].hState[TSR_PRM_BOOTCNT] == cObjectInfo.hState[TSR_PRM_BOOTCNT])
          bResult = true
          break
        end
      }

      return bResult  # [Bool]����ǥ������֤Ǽ¹Ծ��֤Τޤޤ��󥿥��������뤫
    end

    #=================================================================
    # ��  ��: ��������⡼�ɤ�Ƚ�̷�̤��֤�
    #=================================================================
    def is_gain_time_mode?()
      # all_gain_mode��off (+ �������ؿ�������)
      unless (@cConf.is_all_gain_time_mode?())
        # gain_time��true
        if (@hVariation[TSR_PRM_GAIN_TIME] == true)
          # �����������������
          if (is_time_control_situation?())
            raise(TTCExcludeError.new("T6_011: " + ERR_VARIATION_MUST_STOP_TIME))  # (�ѥ�����2)
          # ������������������ʤ�
          else
            return true  # [Bool]��������⡼��(�ѥ�����3)
          end
        # gain_time��false����ά
        else
          return false  # [Bool]��������⡼��(�ѥ�����4)
        end
      # all_gain_mode��on
      else
        # �������ؿ����ʤ�
        if (@cConf.get_func_time() == false)
          # gain_time��true����ά
          if (@hVariation[TSR_PRM_GAIN_TIME] != false)
            # �����������������
            if (is_time_control_situation?())
              ### T6_001: �������ؿ���ɬ�פʤΤ˻����Բ�
              raise(TTCExcludeError.new("T6_001: " + ERR_VARIATION_CANNOT_STOP_TIME))  # (�ѥ�����5)
            # ������������������ʤ�
            else
              return true  # [Bool]��������⡼��(�ѥ�����6)
            end
          # gain_time��false
          else
            ### T6_001: �������ؿ���ɬ�פʤΤ˻����Բ�
            raise(TTCExcludeError.new("T6_001: " + ERR_VARIATION_CANNOT_CONTROL_TIME))  # (�ѥ�����7)
          end
        # �������ؿ�������
        else
          case @hVariation[TSR_PRM_GAIN_TIME]
          when true
            # �����������������
            if (is_time_control_situation?())
              raise(TTCExcludeError.new("T6_011: " + ERR_VARIATION_MUST_STOP_TIME))  # (�ѥ�����8)
            # ������������������ʤ�
            else
              return true  # [Bool]��������⡼��(�ѥ�����9)
            end
          when false
            return false  # [Bool]��������⡼��(�ѥ�����10)
          else
            # �����������������
            if (is_time_control_situation?())
              return false  # [Bool]��������⡼��(�ѥ�����11)
            # ������������������ʤ�
            else
              return true  # [Bool]��������⡼��(�ѥ�����12)
            end
          end
        end
      end

      # ������ξ��ˤ���פ��ʤ�
      abort(ERR_MSG % [__FILE__, __LINE__])
    end
    private :is_gain_time_mode?

    #=================================================================
    # ��  ��: ����������������������֤�
    #=================================================================
    def is_time_control_situation?()
      bResult = false
      # ������ƥ��å���������Ͼ���������
      if (@bHasTimeTick == true)
        bResult = true
      # ������ƥ��å����ʤ����ϥ���ǥ�����󤴤Ȥ˾�������å�
      else
        aCondition = get_all_condition()
        aCondition.each{|cCondition|
          if (cCondition.is_time_control_situation?(@hVariation))
            bResult = true
            break
          end
        }
      end

      return bResult  # [Bool]�������������������
    end
    private :is_time_control_situation?

    #=================================================================
    # ��  ��: ������ǥ�������������֤�
    #=================================================================
    def get_all_condition()
      aCondition = [@cPreCondition]
      aCondition.concat(@aDo_PostCondition)

      return aCondition  # [Array]������ǥ������
    end
    private :get_all_condition

    #=================================================================
    # ��  ��: �����Х��б��Τ���ѥ�᡼�����Ѵ���¹Ԥ���
    #=================================================================
    def convert_global()
      # �����।�٥�ȥϥ�ɥ�Υץ��å�ID��1���फ�ġ�
      # �����Х��ִ��о�°����������줿�ޥ���ǻ��ꤵ��Ƥ���ʤ�Х����Х��ִ�
      aTimeEvtMacro = get_time_event_prcid()
      if (aTimeEvtMacro.size() == 1 && is_global_attribute_all_macro?())
        # 2������3������Ƚ��
        aMacro = get_all_prcid()
        if (aMacro.include?(CFG_MCR_PRC_OTHER_1) || aMacro.include?(CFG_MCR_PRC_OTHER_2))
          hClassTable = GRP_CONVERT_TABLE_CLASS_MULTI_OTHER
        else
          hClassTable = GRP_CONVERT_TABLE_CLASS_SINGLE_OTHER
        end

        hTable = make_table(aTimeEvtMacro[0])
        # ������ǥ�������Ŭ��
        aCondition = get_all_condition()
        aCondition.each{|cCondition|
          cCondition.convert_global(hTable, hClassTable)
        }
      end
    end

    #=================================================================
    # ��  ��: �����।�٥�ȥϥ�ɥ�Υץ��å�ID���֤�
    #=================================================================
    def get_time_event_prcid()
      aMacro = []
      aCondition = get_all_condition()
      aCondition.each{|cCondition|
        hObjects = cCondition.get_objects_by_type(GRP_TIME_EVENT_HDL)
        hObjects.each_value{|cObjectInfo|
          # �ץ��å�ID��Ͽ
          aMacro.push(cObjectInfo.hState[TSR_PRM_PRCID])
        }
      }

      return aMacro.uniq()  # [Array]�����।�٥�ȥϥ�ɥ�Υץ��å�ID
    end

    #=================================================================
    # ������: Ϳ����줿�ץ��å�ID�ξ��󤫤��Ѵ��ơ��֥�������֤�
    #=================================================================
    def make_table(sTimePrcid)
      check_class(String, sTimePrcid)  # �����޴����ץ��å�ID�Ȥʤ�ޥ���

      # ���Ȥʤ��Ѵ��ơ��֥�ʥ���: �Ѵ�������: �Ѵ����
      hTable = {
        TTC_GLOBAL_KEY_SELF    => TTC_GLOBAL_KEY_SELF,
        TTC_GLOBAL_KEY_OTHER   => TTC_GLOBAL_KEY_OTHER,
        TTC_GLOBAL_KEY_OTHER_1 => TTC_GLOBAL_KEY_OTHER_1,
        TTC_GLOBAL_KEY_OTHER_2 => TTC_GLOBAL_KEY_OTHER_2
      }
      hTempHash = TTC_GLOBAL_TABLE[TTC_GLOBAK_KEY_PRCID][:local].invert()
      lPrevKey = hTempHash[sTimePrcid]
      # �����ؤ�
      hTable[lPrevKey]            = TTC_GLOBAL_KEY_SELF
      hTable[TTC_GLOBAL_KEY_SELF] = lPrevKey

      return hTable  # [Hash]�Ѵ��ơ��֥�
    end
    private :make_table

    #=================================================================
    # ������: �����Х��ִ��о�°�������ƥޥ�����������Ƥ��뤫
    #=================================================================
    def is_global_attribute_all_macro?()
      aCondition = get_all_condition()
      return aCondition.all?(){|cCondition|
        cCondition.is_global_attribute_all_macro?()
      }  # [Bool]�����Х��ִ��о�°�������ƥޥ�����������Ƥ��뤫
    end

    #=================================================================
    # ������: �����֥������Ȥˤ����ƻ��ꤵ��Ƥ��ʤ�°���򥻥å�
    #=================================================================
    def set_nil_attribute()
      aCondition = get_all_condition()
      aCondition.each{|cCondition|
        cCondition.set_nil_attribute()
      }
    end

=begin
    #=================================================================
    # ������: ������ֹ�������������
    #=================================================================
    def get_all_intno()
      return @cPreCondition.get_all_intno()  # [Array]������ֹ����
    end
=end
  end
end
