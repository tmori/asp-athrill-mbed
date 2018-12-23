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
#  $Id: Condition.rb 9 2012-09-11 01:47:48Z nces-shigihara $
#
require "ttc/bin/class/TTCCommon.rb"

#=====================================================================
# CommonModule
#=====================================================================
module CommonModule
  #===================================================================
  # ���饹̾: Condition
  # ��    ��: pre_condition, post_condition�ξ����������륯�饹
  #===================================================================
  class Condition
    include TTCModule

    #=================================================================
    # ������: ���֥������Ȥζ��̴��å����å�
    #=================================================================
    def common_basic_check(sObjectID, hObjectInfo, aPath)
      check_class(Object, sObjectID, true)     # ���֥�������ID
      check_class(Object, hObjectInfo, true)   # ����ǥ������
      check_class(Array, aPath)                # �롼�Ȥ���Υѥ�

      aErrors = []
      ### T1_015: ���֥�������ID��ʸ��������
      unless (sObjectID =~ TSR_REX_OBJECT_ID)
        sErr = sprintf("T1_015: " + ERR_INVALID_OBJECTID, sObjectID)
        aErrors.push(YamlError.new(sErr, aPath))
      end
      ### T1_016: ���֥������Ȥ�Hash�ǤϤʤ�
      unless (hObjectInfo.is_a?(Hash))
        sErr = sprintf("T1_016: " + ERR_INVALID_TYPE, sObjectID, Hash, hObjectInfo.class())
        aErrors.push(YamlError.new(sErr, aPath + [sObjectID]))
      end

      check_error(aErrors)
    end

    #=================================================================
    # ��  ��: °�������å�
    #=================================================================
    def attribute_check()
      aErrors = []
      @hAllObject.each{|sObjectID, cObjectInfo|
        begin
          cObjectInfo.attribute_check()
        rescue TTCMultiError
          aErrors.concat($!.aErrors)
        end
      }
      check_error(aErrors)
    end

    #=================================================================
    # ��  ��: ���֥������ȥ����å�
    #=================================================================
    def object_check(bIsPre = false)
      check_class(Bool, bIsPre)  # pre_condition��

      aErrors = []
      @hAllObject.each{|sObjectID, cObjectInfo|
        begin
          cObjectInfo.object_check(bIsPre)
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
      aPath = get_condition_path()

      # CPU_STATE�Υ����å�
      aCpuStateCount = []
      aCpuState      = []
      hObjects       = get_objects_by_type(TSR_OBJ_CPU_STATE)
      hObjects.each_value{|cObjectInfo|
        nPrcid = cObjectInfo.get_process_id()
        if (aCpuStateCount[nPrcid].nil?())
          aCpuStateCount[nPrcid] = 1
        else
          aCpuStateCount[nPrcid] += 1
        end
        aCpuState[nPrcid] = cObjectInfo

=begin
        # loc_id
        unless (cObjectInfo.hState[TSR_PRM_LOC_ID].nil?())
          sLocID = cObjectInfo.hState[TSR_PRM_LOC_ID]
          if (@hAllObject.has_key?(sLocID))
            cProcUnit = @hAllObject[sLocID]
            if (GRP_PROCESS_UNIT_ALL.include?(cProcUnit.sObjectType))
              ### T4_043: loc_id�ǻ��ꤵ�줿����ñ�̤��¹Ծ��֤Ǥʤ�
              unless (cProcUnit.is_activate?())
                sErr = sprintf(ERR_TARGET_NOT_ACTIVATE, sLocID)
                aErrors.push(YamlError.new("T4_043: " + sErr, aPath))
              end
            ### T4_042: loc_id�ǻ��ꤵ�줿���֥������Ȥ�����ñ�̤Ǥʤ�
            else
              sErr = sprintf(ERR_TARGET_NOT_PROCESS_UNIT, sLocID)
              aErrors.push(YamlError.new("T4_042: " + sErr, aPath))
            end
          ### T4_041: loc_id�ǻ��ꤵ�줿���֥������Ȥ�¸�ߤ��ʤ�
          else
            sErr = sprintf(ERR_TARGET_NOT_DEFINED, sLocID)
            aErrors.push(YamlError.new("T4_041: " + sErr, aPath))
          end
        end
=end
      }
      # �����å�
      aCpuStateCount.each_with_index{|nCount, nPrcid|
        ### T4_006: CPU_STATE��1�ĤΥץ��å���2�İʾ�¸�ߤ��Ƥ���
        if (!nCount.nil?() && nCount > 1)
          sErr = sprintf("T4_006: " + ERR_PLURAL_CPU_STATE, nPrcid)
          aErrors.push(YamlError.new(sErr, aPath))
        end
      }

      # ����ñ�̤Υ����å�
      hActivate = Hash.new{|hash, key|
        hash[key] = {
          :nTask         => 0,  # �¹���Υ������ο�
          :nNonContext   => 0,  # �¹�����󥿥�������ƥ����Ȥο�
          :nTaskExc      => 0,  # �¹���Υ������㳰�ο�
          :nException    => 0   # �¹����CPU�㳰�ο�
        }
      }
      (1..@cConf.get_prc_num()).each{|nPrcid|
        hActivate[nPrcid]
      }

      hAllVariable = {}
      aActivate = get_activate_by_prcid()
      hObjects = get_objects_by_type(GRP_PROCESS_UNIT_ALL)
      hObjects.each{|sObjectID, cObjectInfo|
        # �ץ��å��ֹ����
        nPrcid = get_process_prcid(cObjectInfo)
        if (nPrcid.nil?())
          next
        end
        # ��ư��ν���ñ��
        if (cObjectInfo.is_activate?())
          # ��ư��ν���ñ�̤�Ƚ��
          if (cObjectInfo.sObjectType == TSR_OBJ_TASK)
            hActivate[nPrcid][:nTask] += 1
          elsif (cObjectInfo.sObjectType == TSR_OBJ_TASK_EXC)
            hActivate[nPrcid][:nTaskExc] += 1
          elsif (cObjectInfo.sObjectType == TSR_OBJ_EXCEPTION)
            hActivate[nPrcid][:nException] += 1
          end
          if (GRP_NON_CONTEXT.include?(cObjectInfo.sObjectType))
            hActivate[nPrcid][:nNonContext] += 1
          end
        end
        # �ѿ������
        unless (cObjectInfo.hState[TSR_PRM_VAR].nil?())
          hAllVariable[sObjectID] = cObjectInfo.hState[TSR_PRM_VAR]
          # �ͤ����åȤ��줿�ѿ��Υ����å�
          if (cObjectInfo.is_value_set_variable?())
            ### T4_007: �¹Ծ��֤Ǥʤ�����ñ�̤��ѿ���value���������Ƥ���
            if (cObjectInfo.is_activate?())
              if (!aActivate[nPrcid].nil?() && aActivate[nPrcid] != cObjectInfo)
                aErrors.push(YamlError.new("T4_007: " + ERR_SET_VALUE_NON_ACTIVATE, aPath + [cObjectInfo.sObjectID]))
              end
            else
              aErrors.push(YamlError.new("T4_007: " + ERR_SET_VALUE_NON_ACTIVATE, aPath + [cObjectInfo.sObjectID]))
            end
          end
        end
      }

      # ��ư��ν���ñ�̥����å�
      hActivate.each{|nPrcid, hCheck|
        ### T4_008: Ʊ�쥳��ǥ��������Ǽ¹Ծ��֤Υ�������ʣ��¸�ߤ���
        if (hActivate[nPrcid][:nTask] > 1)
          sErr = sprintf("T4_008: " + ERR_PLURAL_RUNNING_TASK, nPrcid)
          aErrors.push(YamlError.new(sErr, aPath))
        end
        ### T4_009: Ʊ�쥳��ǥ��������ǵ�ư����󥿥�������ƥ����Ȥ�ʣ��¸�ߤ���
        if (hActivate[nPrcid][:nNonContext] > 1)
          sErr = sprintf("T4_009: " + ERR_PLURAL_ACTIVATE_NON_CONTEXT, nPrcid)
          aErrors.push(YamlError.new(sErr, aPath))
        end
        # CPU_STATE����Ϣ��������å�
        unless (aCpuState[nPrcid].nil?())
          ### T4_010: �¹Ծ��֤ν���ñ�̤�¸�ߤ��ʤ����֤�CPU����(CPU��å����� | �ǥ����ѥå��ػ߾��� | ����߶ػߥޥ��� != 0)����ꤷ�Ƥ���
          aValues = hActivate[nPrcid].values()
          if (aValues.max() == 0 && aCpuState[nPrcid].is_state_changed?())
            sErr = sprintf("T4_010: " + ERR_CANNNOT_REF_CPU_STATE, nPrcid)
            aErrors.push(YamlError.new(sErr, aPath))
          end
=begin
          ### T4_011: ���顼��ϥ�ɥ餷�����ʤ��Τ�CPU��å��ʳ���CPU���֤����ꤵ��Ƥ���
          if (hActivate[nPrcid][:nAlarm] > 0 && hActivate[nPrcid][:nNonAlarm] == 0 &&
              (aCpuState[nPrcid].is_disable_dispatch?() || !aCpuState[nPrcid].is_enable_interrupt?()))
            sErr = sprintf("T4_011: " + ERR_ONLY_ALARM_SET_CPU_STATE, nPrcid)
            aErrors.push(YamlError.new(sErr, aPath))
          end

          ### T4_012: �����������顼�बư��Ƥ��ʤ��Τ�CPU��å����֤����ꤵ��Ƥ���
          if (hActivate[nPrcid][:nTask] == 0 && hActivate[nPrcid][:nAlarm] == 0 && aCpuState[nPrcid].is_cpu_lock?())
            sErr = sprintf("T4_012: " + ERR_CPULOCK_NOT_TASK_ALARM_RUN, nPrcid)
            aErrors.push(YamlError.new(sErr, aPath))
          end

          # loc_id
          unless (aCpuState[nPrcid].hState[TSR_PRM_LOC_ID].nil?())
            ### T4_044: loc_id�����ꤵ�줿CPU_STATE��Ʊ���ץ��å���ACTIVATE��CPU�㳰�ϥ�ɥ餬¸�ߤ��ʤ�
            if (hActivate[nPrcid][:nException] == 0)
              aErrors.push(YamlError.new("T4_044: " + ERR_NO_EXCEPTION_SET_LOC_ID, aPath))
            end
            ### T4_045: loc_id�����ꤵ�줿CPU_STATE��Ʊ���ץ��å���CPU�㳰�ϥ�ɥ�ʳ��μ¹���ν���ñ�̤�¸�ߤ��ʤ�
            if (hActivate[nPrcid][:nNonException] == 0)
              aErrors.push(YamlError.new("T4_045: " + ERR_NO_PROCESS_UNIT_SET_LOC_ID, aPath))
            end
          end
=end
        end
      }


      # ������
      aPOrder = []
      hObjects = get_objects_by_type(TSR_OBJ_TASK)
      hObjects.each{|sObjectID, cObjectInfo|
        ### T4_013: �Ԥ����֤ˤ������Ԥ��оݥ��֥������Ȥ�¸�ߤ��ʤ�
        if (cObjectInfo.has_wait_object?())
          sWaitObjID = cObjectInfo.hState[TSR_PRM_WOBJID]
          unless (@hAllObject.has_key?(sWaitObjID))
            sErr = sprintf("T4_013: " + ERR_NO_WAITING_OBJECT, sWaitObjID)
            aErrors.push(YamlError.new(sErr, aPath + [sObjectID, TSR_PRM_WOBJID]))
          end
        end
        # porder�����å�����
        if (cObjectInfo.is_activate?() || cObjectInfo.is_ready?())
          nPrcid = get_process_prcid(cObjectInfo)
          nPri   = cObjectInfo.hState[TSR_PRM_TSKPRI]
          unless (cObjectInfo.hState[TSR_PRM_PORDER].nil?())
            nPOrder = cObjectInfo.hState[TSR_PRM_PORDER]
            if (aPOrder[nPrcid].nil?())
              aPOrder[nPrcid] = []
            end
            if (aPOrder[nPrcid][nPri].nil?())
              aPOrder[nPrcid][nPri] = []
            end
            if (aPOrder[nPrcid][nPri][nPOrder].nil?())
              aPOrder[nPrcid][nPri][nPOrder] = []
            end
            aPOrder[nPrcid][nPri][nPOrder].push(sObjectID)
          end
        end
      }
      # porder�����å�
      aPOrder.each_with_index{|aPriByPrcid, nPrcid|
        unless (aPriByPrcid.nil?())
          aPriByPrcid.each_with_index{|aPri, nPri|
            unless (aPri.nil?())
              bCheckFlag = false
              aPri.each_with_index{|aTasks, nPorder|
                if (nPorder != 0)
                  ### T4_014: Ʊ��ͥ�������porder��Ϣ�֤Ǥʤ�
                  if (aTasks.nil?())
                    if (bCheckFlag == true)
                      sErr = sprintf("T4_014: " + ERR_PORDER_NOT_SEQUENCE, nPri, nPrcid)
                      aErrors.push(YamlError.new(sErr, aPath))
                    end
                  ### T4_015: Ʊ��ͥ�������porder����ˡ����Ǥʤ�
                  else
                    bCheckFlag = true
                    if (aTasks.size() > 1)
                      sErr = sprintf("T4_015: " + ERR_PORDER_NOT_UNIQUE, aTasks.join(", "))
                      aErrors.push(YamlError.new(sErr, aPath))
                    end
                  end
                end
              }
            end
          }
        end
      }


      # CPU�㳰�ϥ�ɥ�
      hException = Hash.new{|hash, snExcno|
        hash[snExcno] = []
      }
      hObjects = get_objects_by_type(TSR_OBJ_EXCEPTION)
      hObjects.each{|sObjectID, cObjectInfo|
        # activate�ʾ��
        if (cObjectInfo.is_activate?())
          nPrcid = cObjectInfo.get_process_id()
          ### T4_016: ACTIVATE�Ǥ���CPU�㳰�ϥ�ɥ餬¸�ߤ���ץ��å��ˡ��¹���Υ��������������㳰��¸�ߤ��ʤ�
          if (hActivate[nPrcid][:nTask] == 0 && hActivate[nPrcid][:nTaskExc] == 0)
            sErr = sprintf("T4_016: " + ERR_NO_TASK_CONTEXT_ON_OBJ, TSR_OBJ_EXCEPTION)
            aErrors.push(YamlError.new(sErr, aPath))
          end
        end
        # CPU�㳰�ϥ�ɥ��ֹ�
        snExcno = cObjectInfo.hState[TSR_PRM_EXCNO]
        hException[snExcno].push(sObjectID)
      }
      # �����å�
      hException.each{|snExcno, aObjectID|
        ### T4_017: Ʊ��CPU�㳰�ϥ�ɥ��ֹ���Ф���CPU�㳰�ϥ�ɥ餬ʣ���������Ƥ���
        if (aObjectID.size() > 1)
          sErr = sprintf("T4_017: " + ERR_DUPLICATE_EXCNO, snExcno, aObjectID.join(", "))
          aErrors.push(YamlError.new(sErr, aPath))
        end
      }


      # �������㳰
      hObjects = get_objects_by_type(TSR_OBJ_TASK_EXC)
      hObjects.each{|sObjectID, cObjectInfo|
        # ��Ϣ������
        cTask = @hAllObject[cObjectInfo.hState[TSR_PRM_TASK]]
        if (!cTask.nil?() && cTask.sObjectType == TSR_OBJ_TASK)
          if (cTask.is_dormant?())
            ### T4_018: ��Ϣ�������ξ��֤�dormant�Ǥ���Τ˥������㳰��ͭ��
            if (cObjectInfo.is_activate?())
              sErr = sprintf("T4_018: " + ERR_TASK_EXC_CANNOT_ACTIVATE, cTask.sObjectID)
              aErrors.push(YamlError.new(sErr, aPath + [sObjectID]))
            end
            # �ѥ�᡼����������å�
            cObjectInfo.hState.each_key{|sAtr|
              ### T4_019: ��Ϣ��������dormant�Ǥ�����ˡ������ԲĤʥѥ�᡼�������ꤵ��Ƥ���
              sRealAtr = cObjectInfo.get_real_attribute_name(sAtr)
              if (cObjectInfo.is_specified?(sRealAtr) && !GRP_ACTIVATE_PRM_ON_DORMANT[TSR_OBJ_TASK_EXC].include?(sRealAtr))
                sErr = sprintf("T4_019: " + ERR_ATR_DORMANT_TASK_EXC, sRealAtr)
                aErrors.push(YamlError.new(sErr, aPath + [sObjectID]))
              end
            }
          ### T4_020: ��Ϣ��������dormant�Ǥʤ�����texstat�����ꤵ��Ƥ��ʤ�
          elsif (cObjectInfo.hState[TSR_PRM_STATE].nil?())
            sErr = sprintf("T4_020: " + ERR_NO_TEXSTAT_STT_NOT_DORMANT, cTask.sObjectID)
            aErrors.push(YamlError.new(sErr, aPath + [sObjectID]))
          end
        end
      }


      # ����ߥϥ�ɥ顤����ߥ����ӥ��롼����
      hIntno = Hash.new{|hash, snIntno|
        hash[snIntno] = {
          TSR_OBJ_INTHDR => [],
          TSR_OBJ_ISR    => []
        }
      }
      hObjects = get_objects_by_type([TSR_OBJ_INTHDR, TSR_OBJ_ISR])
      hObjects.each{|sObjectID, cObjectInfo|
        # ������ֹ椴�ȤˤޤȤ��
        snIntno = cObjectInfo.hState[TSR_PRM_INTNO]
        hIntno[snIntno][cObjectInfo.sObjectType].push(cObjectInfo)
        ### T4_038: ACTIVATE�Ǥ������ߥϥ�ɥ餬¸�ߤ���ץ��å��ˡ��¹���Υ��������������㳰��¸�ߤ��ʤ�
        ### T4_039: ACTIVATE�Ǥ������ߥ����ӥ��롼����¸�ߤ���ץ��å��ˡ��¹���Υ��������������㳰��¸�ߤ��ʤ�
        if (cObjectInfo.is_activate?())
          nPrcid = get_process_prcid(cObjectInfo)
          if (hActivate[nPrcid][:nTask] == 0 && hActivate[nPrcid][:nTaskExc] == 0)
            sErr = sprintf(ERR_NO_TASK_CONTEXT_ON_OBJ, cObjectInfo.sObjectType)
            if (cObjectInfo.sObjectType == TSR_OBJ_INTHDR)
              sErr = "T4_038: " + sErr
            else
              sErr = "T4_039: " + sErr
            end
            aErrors.push(YamlError.new(sErr, aPath))
          end
        end
      }
      # ������ֹ�����ܤ��������å�
      hIntno.each{|snIntno, hItem|
        ### T4_023: intno��Ʊ���Ǥ���INTHDR��ʣ���������Ƥ���
        if (hItem[TSR_OBJ_INTHDR].size() > 1)
          aObjectID = []
          hItem[TSR_OBJ_INTHDR].each{|cObjectInfo|
            aObjectID.push(cObjectInfo.sObjectID)
          }
          sErr = sprintf("T4_023: " + ERR_INTHDR_DUPLICATE, snIntno, aObjectID.join(", "))
          aErrors.push(YamlError.new(sErr, aPath))
        end
        ### T4_025: intno��Ʊ���Ǥ���INTHDR��ISR���������Ƥ���
        if (hItem[TSR_OBJ_INTHDR].size() > 0 && hItem[TSR_OBJ_ISR].size() > 0)
          sErr = sprintf("T4_025: " + ERR_INTNO_DUPLICATE, snIntno)
          aErrors.push(YamlError.new(sErr, aPath))
        end
        # intstat�Υ����å�
        if (hItem[TSR_OBJ_ISR].size() > 1)
          sIntStat = nil
          hItem[TSR_OBJ_ISR].each{|cObjectInfo|
            if (sIntStat.nil?())
              sIntStat = cObjectInfo.hState[TSR_PRM_STATE]
            ### T4_024: intno��Ʊ���Ǥ���ISR��ʣ���������Ƥ������intstat�����פ��Ƥ��ʤ�
            elsif (sIntStat != cObjectInfo.hState[TSR_PRM_STATE])
              sErr = sprintf("T4_024: " + ERR_ISR_PRM_MISMATCH, snIntno)
              aErrors.push(YamlError.new(sErr, aPath))
            end
          }
        end
      }


      # Ʊ���̿����֥�������
      aTaskListAtr = [TSR_PRM_WTSKLIST, TSR_PRM_STSKLIST, TSR_PRM_RTSKLIST]
      hObjects = get_objects_by_type(GRP_SC_OBJECT)
      hObjects.each{|sObjectID, cObjectInfo|
        # �������ꥹ�ȤΥ����å�
        aTaskListAtr.each{|sAtr|
          unless (cObjectInfo.hState[sAtr].nil?())
            cObjectInfo.hState[sAtr].each{|hTask|
              hTask.each{|sTask, hVar|
                # ��Ͽ���줿�������Υ����å�
                if (@hAllObject.has_key?(sTask))
                  cTask = @hAllObject[sTask]
                  if (cTask.sObjectType == TSR_OBJ_TASK)
                    # �������ξ��֥����å�
                    if (cTask.is_object_waiting?())
                      ### T4_026: �Ԥ��������ꥹ�Ȥ���Ͽ���줿���������Ԥ��оݤ������Ԥ��������ꥹ�Ȥ�
                      ###       : ���ĥ��֥������ȤȰۤʤ�
                      if (cTask.hState[TSR_PRM_WOBJID] != sObjectID)
                        sErr = sprintf("T4_026: " + ERR_TSKLIST_TASK_TARGET_MISMATCH, sTask, sObjectID)
                        aErrors.push(YamlError.new(sErr, aPath + [sObjectID, sAtr]))
                      end
                    ### T4_027: �Ԥ��������ꥹ�Ȥ���Ͽ���줿���������Ԥ����֤�����Ԥ����֤Ǥʤ�
                    else
                      sErr = sprintf("T4_027: " + ERR_TSKLIST_TASK_NOT_WAITING, sTask)
                      aErrors.push(YamlError.new(sErr, aPath + [sObjectID, sAtr]))
                    end
                  ### T4_029: �Ԥ��������ꥹ�Ȥ���Ͽ���줿���֥������Ȥ��������Ǥʤ�
                  else
                    sErr = sprintf("T4_029: " + ERR_TARGET_NOT_TASK, sTask)
                    aErrors.push(YamlError.new(sErr, aPath + [sObjectID, sAtr]))
                  end
                ### T4_028: �Ԥ��������ꥹ�Ȥ���Ͽ���줿���֥������Ȥ�¸�ߤ��ʤ�
                else
                  sErr = sprintf("T4_028: " + ERR_TARGET_NOT_DEFINED, sTask)
                  aErrors.push(YamlError.new(sErr, aPath + [sObjectID, sAtr]))
                end
              }
            }
          end

          # �ѿ��Υ����å�
          # wtsklist��rtsklist
          aTaskListVars = []
          aTaskListVars.push(cObjectInfo.get_rtsklist_variable())
          aTaskListVars.push(cObjectInfo.get_wtsklist_variable())
          aTaskListVars.each{|hVars|
            hVars.each{|sTask, hVar|
              if (@hAllObject.has_key?(sTask) && @hAllObject[sTask].sObjectType == TSR_OBJ_TASK)
                hVar.each{|sVarName, aType|
                  hVarAtr = @hAllObject[sTask].hState[TSR_PRM_VAR]
                  if (!hVarAtr.nil?() && hVarAtr.has_key?(sVarName))
                    ### T4_030: �Ԥ��������ꥹ�Ȥ���Ͽ���줿�Ԥ�������ѿ���Ŭ�ڤʷ��Ǥʤ�
                    unless (aType.include?(hVarAtr[sVarName].sType))
                      sErr = sprintf("T4_030: " + ERR_VARIABLE_TYPE_MISMATCH, sVarName, sTask, aType.join(", "))
                      aErrors.push(YamlError.new(sErr, aPath + [sObjectID, TSR_PRM_RTSKLIST, sTask]))
                    end
                  ### T4_031: �Ԥ��������ꥹ�Ȥ���Ͽ���줿�Ԥ�������ѿ������������������Ƥ��ʤ�
                  else
                    sErr = sprintf("T4_031: " + ERR_VARIABLE_NOT_DEFINED, sVarName, sTask)
                    aErrors.push(YamlError.new(sErr, aPath + [sObjectID, TSR_PRM_RTSKLIST, sTask]))
                  end
                }
              end
            }
          }
          # msglist
          hVar = cObjectInfo.get_msglist_variable()
          hVar.each{|sVarName, aType|
            hAllVariable.each{|sProcObjectID, hProcVar|
              if (hProcVar.has_key?(sVarName))
                cVar = hProcVar[sVarName]
                ### T4_035: msglist�Υ�å������������ѿ���Ŭ�ڤʷ����������Ƥ��ʤ�
                unless (aType.include?(cVar.sType))
                  sErr = sprintf("T4_035: " + ERR_VARIABLE_TYPE_MISMATCH, sVarName, sProcObjectID, aType.join(", "))
                  aErrors.push(YamlError.new(sErr, aPath + [sObjectID, TSR_PRM_MSGLIST]))
                end
              end
            }
          }
        }

        # ����ס���
        if (cObjectInfo.sObjectType == TSR_OBJ_MEMORYPOOL && !cObjectInfo.hState[TSR_PRM_MPF].nil?())
          hAllVariable.each{|sProcObjectID, hVar|
            hVar.each{|sVarName, cVar|
              if (sVarName == cObjectInfo.hState[TSR_PRM_MPF])
                ### T4_032: ����ס������Ƭ���Ϥ����������ѿ�����Ľ���ñ�̤��¹Ծ��֤Ǥʤ����ˤ����ѿ����ǧ���褦�Ȥ��Ƥ���
                unless (@hAllObject[sProcObjectID].is_activate?())
                  sErr = sprintf("T4_032: " + ERR_MPF_NOT_ACTIVATE, sProcObjectID, cObjectInfo.hState[TSR_PRM_MPF])
                  aErrors.push(YamlError.new(sErr, aPath + [sObjectID, TSR_PRM_MPF]))
                end
                ### T4_033: ����ס������Ƭ���Ϥ����������ѿ���Ŭ�ڤʷ��Ǥʤ�
                if (cVar.sType != TYP_VOID_P)
                  sErr = sprintf("T4_033: " + ERR_VARIABLE_TYPE_MISMATCH, sVarName, sProcObjectID, TYP_VOID_P)
                  aErrors.push(YamlError.new(sErr, aPath + [sObjectID, TSR_PRM_MPF]))
                end
             end
            }
          }
        end
      }


      # FMP����
      if (@cConf.is_fmp?())
        # ���ԥ��å�
        aSpinlock = []
        hObjects = get_objects_by_type(TSR_OBJ_SPINLOCK)
        hObjects.each{|sObjectID, cObjectInfo|
          if (cObjectInfo.is_lock?())
            sProcID = cObjectInfo.hState[TSR_PRM_PROCID]
            if (@hAllObject.has_key?(sProcID))
              cProcUnit = @hAllObject[sProcID]
              if (GRP_PROCESS_UNIT_ALL.include?(cProcUnit.sObjectType))
                nPrcid  = get_process_prcid(cProcUnit)
                unless (nPrcid.nil?())
                  aSpinlock[nPrcid] = true
                  # CPU_STATE���������Ƥ��뤫
                  unless (aCpuState[nPrcid].nil?())
                    ### T4_F002: ���ԥ��å����CPU��å��ˤʤäƤ��ʤ�
                    unless (aCpuState[nPrcid].is_cpu_lock?())
                      sErr = sprintf("T4_F002: " + ERR_NOT_CPU_LOCK_IN_SPINLOCK, nPrcid)
                      aErrors.push(YamlError.new(sErr, aPath))
                    end
                  ### T4_F001: ���ԥ��å����CPU_STATE���������Ƥ��ʤ�
                  else
                    sErr = sprintf("T4_F001: " + ERR_NO_CPU_STATE_IN_SPINLOCK, nPrcid)
                    aErrors.push(YamlError.new(sErr, aPath))
                  end
                end
              ### T4_F004 ���ԥ��å����������֥������Ȥ�����ñ�̤ǤϤʤ�
              else
                sErr = sprintf("T4_F004: " + ERR_TARGET_NOT_PROCESS_UNIT, sProcID)
                aErrors.push(YamlError.new(sErr, aPath + [sObjectID, TSR_PRM_PROCID]))
              end
            ### T4_F003: ���ԥ��å����������֥������Ȥ�¸�ߤ��ʤ�
            else
              sErr = sprintf("T4_F003: " + ERR_TARGET_NOT_DEFINED, sProcID)
              aErrors.push(YamlError.new(sErr, aPath + [sObjectID, TSR_PRM_PROCID]))
            end
          end
        }


        # ����ñ��
        hObjects = get_objects_by_type(GRP_PROCESS_UNIT_ALL)
        hObjects.each{|sObjectID, cObjectInfo|
          # running-suspended�ʥ�����
          if (cObjectInfo.sObjectType == TSR_OBJ_TASK && cObjectInfo.is_running_suspended?())
            nPrcid    = cObjectInfo.get_process_id()
            cCpuState = aCpuState[nPrcid]
            ### T4_F005: ���������֤�running-suspended�λ��˰ʲ��ξ��Τ�������������Ƥ��ʤ�
            ###         * CPU����(ipm != 0 | loc_cpu = true | dis_dsp = true)
            ###         * ���ԥ��å���
            ###         * ACTIVATE���󥿥�����¸��
            if (hActivate[nPrcid][:nNonContext] == 0 && aSpinlock[nPrcid] != true && (cCpuState.nil?() ||
                (cCpuState.is_enable_interrupt?() && !cCpuState.is_cpu_lock?() && !cCpuState.is_disable_dispatch?())))
              sErr = sprintf("T4_F005: " + ERR_CANNOT_RUNNING_SUSPENDED, nPrcid)
              aErrors.push(YamlError.new(sErr, aPath + [sObjectID]))
            end
          end
          # ���ԥ��å��Ԥ�
          if (cObjectInfo.is_spinlock_waiting?())
            sSpinID = cObjectInfo.hState[TSR_PRM_SPINID]
            if (@hAllObject.has_key?(sSpinID))
              cSpinlock = @hAllObject[sSpinID]
              ### T4_F007: ���ԥ��å�ID�Υ��֥������Ȥ����ԥ��å��ǤϤʤ�
              unless (cSpinlock.sObjectType == TSR_OBJ_SPINLOCK)
                sErr = sprintf("T4_F007: " + ERR_TARGET_NOT_SPINLOCK, sSpinID)
                aErrors.push(YamlError.new(sErr, aPath + [sObjectID, TSR_PRM_SPINID]))
              end
            ### T4_F006: ���ԥ��å�ID�Υ��֥������Ȥ�¸�ߤ��ʤ�
            else
              sErr = sprintf("T4_F006: " + ERR_TARGET_NOT_DEFINED, sSpinID)
              aErrors.push(YamlError.new(sErr, aPath + [sObjectID, TSR_PRM_SPINID]))
            end
          end
        }
      end

      check_error(aErrors)
    end

    #=================================================================
    # ������: ����ñ�̤Υץ��å��ֹ���֤�
    #=================================================================
    def get_process_prcid(cObjectInfo)
      check_class(Object, cObjectInfo, true)  # ProcessUnit

      nPrcid = nil
      unless (cObjectInfo.nil?())
        if (@cConf.is_asp?())
          nPrcid = 1
        elsif (@cConf.is_fmp?())
          # �������㳰�ξ���Ϣ��������prcid
          if (cObjectInfo.sObjectType == TSR_OBJ_TASK_EXC)
            cTask = @hAllObject[cObjectInfo.hState[TSR_PRM_TASK]]
            unless (cTask.nil?())
              nPrcid = cTask.hState[TSR_PRM_PRCID]
            end
          else
            nPrcid = cObjectInfo.hState[TSR_PRM_PRCID]
          end
        end
      end

      return nPrcid  # [Integer,NilClass]�ץ��å��ֹ�
    end

    #=================================================================
    # ������: ����ǥ������������ƤΥޥ�����ִ�����
    #=================================================================
    def convert_macro()
      @hAllObject.each_value{|cObjectInfo|
        cObjectInfo.convert_macro()
      }
    end

    #=================================================================
    # ������: �����ꥢ����¹Ԥ���
    #=================================================================
    def alias(hAlias)
      check_class(Hash, hAlias)   # �����ꥢ���Ѵ��ơ��֥�

      hTmp        = @hAllObject.dup()
      @hAllObject = {}
      hTmp.each{|sObjectID, cObjectInfo|
        if (hAlias.has_key?(sObjectID))
          cObjectInfo.alias(hAlias)
          @hAllObject[hAlias[sObjectID]] = cObjectInfo
        else
          abort(ERR_MSG % [__FILE__, __LINE__])
        end
      }
    end

    #=================================================================
    # ������: ���䴰��λ��˼¹Ԥ������
    #=================================================================
    def complement_after()
      @hAllObject.each_value{|cObjectInfo|
        cObjectInfo.complement_after()
      }
    end

    #=================================================================
    # ��  ��: ����ǥ����������Ƥ�YAML���֥������Ȥ��Ѵ������֤�
    #=================================================================
    def to_yaml(bIsPre = false)
      check_class(Bool, bIsPre)  # pre_condition��

      hYaml = {}
      @hAllObject.each{|sObjectID, cObjectInfo|
        hYaml[sObjectID] = cObjectInfo.to_yaml(bIsPre)
      }

      return hYaml  # [Hash]YAML���֥�������
    end

    #=================================================================
    # ��  ��: ����ǥ���������¸�ߤ����ѿ�̾�������֤�
    #=================================================================
    def get_variable_names()
      aVarNames = []
      @hAllObject.each_value{|cObjectInfo|
        aVarNames.concat(cObjectInfo.get_variable_names())
      }
      aVarNames = aVarNames.uniq()

      return aVarNames  # [Array]����ǥ���������¸�ߤ����ѿ�̾����
    end

    #=================================================================
    # ��  ��: ����ǥ���������¸�ߤ���ץ��å��ֹ�������֤�
    #=================================================================
    def get_all_prcid()
      aPrcID = []
      @hAllObject.each_value{|cObjectInfo|
        unless (cObjectInfo.hState[TSR_PRM_PRCID].nil?())
          aPrcID.push(cObjectInfo.hState[TSR_PRM_PRCID])
        end
        unless (cObjectInfo.hState[TSR_PRM_ACTPRC].nil?())
          aPrcID.push(cObjectInfo.hState[TSR_PRM_ACTPRC])
        end
      }

      return aPrcID.compact().uniq()  # [Array]����ǥ���������¸�ߤ���ץ��å��ֹ����
    end

    #=================================================================
    # ��  ��: �ץ��å��ֹ椴�Ȥ˵�ư��ν���ñ�̤��֤�
    #=================================================================
    def get_activate_process_unit_by_prcid()
      aDoProcess = get_activate_by_prcid()
      hObjects   = get_objects_by_type(TSR_OBJ_TASK)
      hObjects.each{|sObjectID, cObjectInfo|
        if (cObjectInfo.is_activate?())
          nPrcid = cObjectInfo.get_process_id()
          if (aDoProcess[nPrcid].nil?())
            cTex = get_task_exc_by_task(sObjectID)
            if (!cTex.nil?() && cTex.is_activate?())
              aDoProcess[nPrcid] = cTex
            else
              aDoProcess[nPrcid] = cObjectInfo
            end
          end
        end
      }

      return aDoProcess  # [Array]�ץ��å��ֹ椴�Ȥ˵�ư��ν���ñ��
    end

    #=================================================================
    # ��  ��: �ץ��å��ֹ椴�Ȥ�activate���󥿥������֤�
    #=================================================================
    def get_activate_by_prcid()
      aActivate = []
      if (@cConf.is_asp?())
        aActivate[1] = get_activate()
      elsif (@cConf.is_fmp?())
        aActivate = get_activate_fmp()
      else
        abort(ERR_MSG % [__FILE__, __LINE__])
      end

      return aActivate  # [Array]�ץ��å��ֹ椴�Ȥ�activate���󥿥������֤�
    end

    #=================================================================
    # ��  ��: ������ID���鳺�����������Ϣ�դ��Ƥ��륿�����㳰���֤�
    #=================================================================
    def get_task_exc_by_task(sObjectID)
      check_class(String, sObjectID)  # ������ID

      cResult = nil
      hObjects = get_objects_by_type(TSR_OBJ_TASK_EXC)
      hObjects.each_value{|cObjectInfo|
        if (cObjectInfo.hState[TSR_PRM_TASK] == sObjectID)
          cResult = cObjectInfo
          break
        end
      }

      return cResult  # [TaskExcept]�������㳰
    end

    #=================================================================
    # ��  ��: �����줫�Υץ��å���CPU��å����֤����֤�
    #=================================================================
    def exist_cpulock?()
      bResult = false

      hObjects = get_objects_by_type(TSR_OBJ_CPU_STATE)
      hObjects.each_value{|cObjectInfo|
        if (cObjectInfo.is_cpu_lock?())
          bResult = true
          break
        end
      }

      return bResult  # [Bool]�����줫�Υץ��å���CPU��å����֤�
    end

    #=================================================================
    # ��  ��: ����������������������֤�
    #=================================================================
    def is_time_control_situation?(hVariation)
      check_class(Hash, hVariation)  # �Хꥨ����������

      bResult = false
      # �����।�٥�ȥϥ�ɥ餬�о줹��(lefttim�����ꤵ��Ƥ���) 
      hObjects = get_objects_by_type(GRP_TIME_EVENT_HDL)
      hObjects.each_value{|cObjectInfo|
        if (cObjectInfo.has_lefttmo?())
          bResult = true
          break
        end
      }

      # �����륿���ޡ������������prcid�����ꤵ��Ƥ�������ϥ�ɥ餬�о줹��
      if (hVariation[TSR_PRM_TIMER_ARCH] == TSR_PRM_TIMER_LOCAL)
        hObjects = get_objects_by_type(TSR_OBJ_CYCLE)
        hObjects.each_value{|cObjectInfo|
          if (cObjectInfo.is_specified?(TSR_PRM_PRCID))
            bResult = true
          end
        }
      end

      # �����ॢ����ͭ��Υ��֥��������Ԥ���������¸�ߤ���
      # �����ॢ����ͭ��ε����Ԥ���������¸�ߤ���
      # ���ַв��Ԥ���������¸�ߤ���(lefttmo�����ꤵ��Ƥ���) 
      # => lefttmo��wobjid�����ꤵ��Ƥ���
      hObjects = get_objects_by_type(TSR_OBJ_TASK)
      hObjects.each_value{|cObjectInfo|
        if (cObjectInfo.has_wait_target?() && cObjectInfo.has_lefttmo?())
          bResult = true
        end
      }

      return bResult  # [Bool]�������������������
    end

    #=================================================================
    # ��  ��: �����Х��б��Τ���ѥ�᡼�����Ѵ���¹Ԥ���
    #=================================================================
    def convert_global(hTable, hClassTable)
      check_class(Hash, hTable)       # �Ѵ��ơ��֥�
      check_class(Hash, hClassTable)  # ���饹�ִ��б�ɽ

      @hAllObject.each_value{|cObjectInfo|
        cObjectInfo.convert_global(hTable, hClassTable)
      }
    end

    #=================================================================
    # ��  ��: ����ߥϥ�ɥ�ǳ�����ֹ椴�Ȥ˥����å�����°�����֤�
    #=================================================================
    def get_inthdr_attributes_by_intno()
      return get_object_attributes_by_attributes(TSR_OBJ_INTHDR, [TSR_PRM_ATR, TSR_PRM_INHNO, TSR_PRM_INTPRI, TSR_PRM_CLASS], [TSR_PRM_INTNO])  # [Hash]������ֹ椴�Ȥγ���°��
    end

    #=================================================================
    # ��  ��: ����ߥ����ӥ��롼����ǳ�����ֹ椴�Ȥ˥����å�����°��
    #       : ���֤�
    #=================================================================
    def get_isr_attributes_by_intno()
      return get_object_attributes_by_attributes(TSR_OBJ_ISR, [TSR_PRM_ATR, TSR_PRM_INTPRI], [TSR_PRM_INTNO])  # [Hash]������ֹ椴�Ȥγ���°��
    end

    #=================================================================
    # ��  ��: ����ߥ����ӥ��롼����ǳ�����ֹ�ȳ����ͥ���٤��Ȥ߹�
    #       : �碌���Ȥ˥����å�����°�����֤�
    #=================================================================
    def get_isr_attributes_by_intno_and_isrpri()
      return get_object_attributes_by_attributes(TSR_OBJ_ISR, [TSR_PRM_EXINF, TSR_PRM_CLASS], [TSR_PRM_INTNO, TSR_PRM_ISRPRI])  # [Hash]������ֹ�ȳ����ͥ���٤��Ȥ߹�碌���Ȥγ���°��
    end

    #=================================================================
    # ��  ��: CPU�㳰�ϥ�ɥ��CPU�㳰�ϥ�ɥ��ֹ椴�Ȥ˥����å�����°
    #       : �����֤�
    #=================================================================
    def get_exception_attributes_by_excno()
      return get_object_attributes_by_attributes(TSR_OBJ_EXCEPTION, [TSR_PRM_CLASS], [TSR_PRM_EXCNO])  # [Hash]CPU�㳰�ϥ�ɥ��ֹ椴�Ȥγ���°��
    end

    #=================================================================
    # ��  ��: ���ꤷ�����֥������Ȥ�°�����ͤ��Ȥ˻��ꤷ��°�����Ȥ߹�
    #       : �碌�򥰥롼��ʬ�������֤�
    #=================================================================
    def get_object_attributes_by_attributes(sObjectType, aTargetAtrs, aAtrsByGroup)
      check_class(String, sObjectType)  # ���֥������ȥ�����
      check_class(Array, aTargetAtrs)   # �Ȥ߹�碌�Ȥ���°��̾
      check_class(Array, aAtrsByGroup)  # ���롼��ʬ���˻Ȥ�°��̾

      hResult = Hash.new{|hash, key|
        hash[key] = []
      }
      hObjects = get_objects_by_type(sObjectType)
      hObjects.each{|sObjectID, cObjectInfo|
        # key
        hKey = {}
        aAtrsByGroup.each{|sAtr|
          sRealAtr       = cObjectInfo.get_real_attribute_name(sAtr)
          hKey[sRealAtr] = cObjectInfo.hState[sAtr]
        }
        # value
        hVal  = {}
        aTargetAtrs.each{|sAtr|
          sRealAtr       = cObjectInfo.get_real_attribute_name(sAtr)
          hVal[sRealAtr] = cObjectInfo.hState[sAtr]
        }
        hResult[hKey].push(hVal)
      }

      # ��ˡ�����
      hResult.each{|hAtrs, aVals|
        hResult[hAtrs] = aVals.uniq()
      }

      return hResult  # [Hash]°�����Ȥ߹�碌(�ϥå���)��������ͤˤ�ĥϥå���
    end
    private :get_object_attributes_by_attributes

    #=================================================================
    # ������: �����Х��ִ��о�°�������ƥޥ�����������Ƥ��뤫
    #=================================================================
    def is_global_attribute_all_macro?()
      return @hAllObject.all?(){|sObjectID, cObjectInfo|
        cObjectInfo.is_global_attribute_all_macro?()
      }  # [Bool]�����Х��ִ��о�°�������ƥޥ�����������Ƥ��뤫
    end

    #=================================================================
    # ������: �����֥������Ȥˤ����ƻ��ꤵ��Ƥ��ʤ�°���򥻥å�
    #=================================================================
    def set_nil_attribute()
      @hAllObject.each_value{|cObjectInfo|
        cObjectInfo.set_nil_attribute()
      }
    end

=begin
    #=================================================================
    # ��  ��: �����줫�Υץ��å��ǳ�����ͥ���٥ޥ��������ꤵ��Ƥ�
    #       : �뤫���֤�
    #=================================================================
    def exist_disable_interrupt?()
      bResult = false

      hObjects = get_objects_by_type(TSR_OBJ_CPU_STATE)
      hObjects.each_value{|cObjectInfo|
        unless (cObjectInfo.is_enable_interrupt?())
          bResult = true
          break
        end
      }

      return bResult  # [Bool]�����줫�Υץ��å��ǳ�����ͥ���٥ޥ��������ꤵ��Ƥ��뤫
    end
=end
  end
end
