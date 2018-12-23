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
#  $Id: PreCondition.rb 9 2012-09-11 01:47:48Z nces-shigihara $
#

#=====================================================================
# CommonModule
#=====================================================================
module CommonModule
  #===================================================================
  # ���饹̾: PreCondition
  # ��    ��: pre_condition�ξ����������륯�饹
  #===================================================================
  class PreCondition < Condition

    #=================================================================
    # ��  ��: ����ͥ���٤Ƚ��ͥ���٤��ۤʤ륿�����򸡺����Ƥ������
    #         true�򡤤ʤ�����false���֤�
    #=================================================================
    def exist_pre_task_pri_chg_fmp()
      @hTask.each{|sObjectID, cObjectInfo|
        if ((cObjectInfo.hState[TSR_PRM_STATE] != KER_TTS_RUN) &&
            (cObjectInfo.hState[TSR_PRM_STATE] != KER_TTS_DMT) &&
            (cObjectInfo.hState[TSR_PRM_STATE] != KER_TTS_RUS) &&
            (cObjectInfo.hState[TSR_PRM_TSKPRI] != cObjectInfo.hState[TSR_PRM_ITSKPRI]) &&
            !(!cObjectInfo.hState[TSR_PRM_WOBJID].nil?() && !GRP_WAIT_NON_OBJECT.include?(cObjectInfo.hState[TSR_PRM_WOBJID])))
          return true # [Bool]����ͥ���٤Ƚ��ͥ���٤��ۤʤ륿������������
        end
      }

      return false # [Bool]����ͥ���٤Ƚ��ͥ���٤��ۤʤ륿�������ʤ����
    end

    #=================================================================
    # ��  ��: ���Ͼ��֤Υ������򸡺����Ƥ������true��
    #         �ʤ�����false���֤�
    #=================================================================
    def exist_pre_task_running_suspended_fmp()
      @hTask.each{|sObjectID, cObjectInfo|
        if (cObjectInfo.hState[TSR_PRM_STATE] == KER_TTS_RUS)
          return true # [Bool]���Ͼ��֤Υ�������������
        end
      }

      return false # [Bool]���Ͼ��֤Υ��������ʤ����
    end

    #=================================================================
    # ��  ��: �оݥ�������ư���ơ��ᥤ�󥿥�����ͥ���٤򲼤��������
    #         cElement�˳�Ǽ����
    #=================================================================
    def set_act_task_fmp(cElement, cObjectInfo)
      check_class(ProcessUnit, cObjectInfo) # �оݥ��������饹

      hMainTaskInfo = get_proc_unit_info()

      # �оݥ�������ư
      cElement.set_syscall(hMainTaskInfo, "#{API_MACT_TSK}(#{cObjectInfo.sObjectID}, #{cObjectInfo.hState[TSR_PRM_PRCID]})")

      # �ᥤ��ץ��å��ʤ�Хᥤ�󥿥�����ͥ���٤򲼤��ƥǥ����ѥå�
      if (cObjectInfo.hState[TSR_PRM_PRCID] == @sMainPrcid)
        cElement.set_syscall(hMainTaskInfo, "#{API_CHG_PRI}(#{TTG_TSK_SELF}, #{TTG_WAIT_PRI})")

        # �оݥ�������ͥ���٤�TTG_WAIT_PRI��Ʊ�����ä���硤rot_rdq��ȯ�Ԥ��ƥǥ����ѥå�������
        if (cObjectInfo.hState[TSR_PRM_TSKPRI] == TTG_WAIT_PRI)
          cElement.set_syscall(hMainTaskInfo, "#{API_ROT_RDQ}(#{TTG_WAIT_PRI})")
        end
      end

    end
    private :set_act_task_fmp


    #=================================================================
    # ��  ��: Ʊ�����̿����֥������Ȥˤ���Ԥ����֥������ν�����֤�
    #         ���������IMCodeElement���饹�ˤޤȤ���֤�
    #=================================================================
    def gc_pre_task_scobj_waiting_fmp()
      # �������򥪥֥��������Ԥ��ˤ��륳���ɥ֥�å����֤�
      # ���ASP_dataqueue_rcv_dtq_f_2_1_1
      #   �ᥤ�󥿥�����TASK2�򵯤������������㳰�ϥ�ɥ餬¸�ߤ������
      #   ����������򤷡�TASK2��ʬ��snd_dtq������
      #   �����Ԥ��ˤ�����(����������Ԥ��ˤʤäƤ��륿�����ο�����)
      #   �ʢ��ץ��å��ν�����ݤ���Ƥ��ʤ���
      cElement      = IMCodeElement.new()
      hMainTaskInfo = get_proc_unit_info()

      @hWaitObject.each{|sObjectID, cObjectInfo|
        # �Ԥ��������Υꥹ��
        if (!cObjectInfo.hState[TSR_PRM_WTSKLIST].nil?() && !cObjectInfo.hState[TSR_PRM_WTSKLIST].empty?())
          cObjectInfo.hState[TSR_PRM_WTSKLIST].each{|aWtskList|
            aWtskList.each_key{|sTaskID|
              cTaskInfo = @hTask[sTaskID]

              # �оݥ������إǥ����ѥå����뤿��Υ�����
              set_act_task_fmp(cElement, cTaskInfo)

              # �оݥ������ξ�������������å��ݥ��������
              hProcUnitInfo = get_proc_unit_info(cTaskInfo)
              cElement.set_checkpoint(hProcUnitInfo)

              case cObjectInfo.sObjectType
              when TSR_OBJ_SEMAPHORE
                # ���ֻ��꤬����Х����ॢ�����դ�API����Ѥ���
                if (cTaskInfo.hState[TSR_PRM_LEFTTMO].nil?())
                  cElement.set_syscall(hProcUnitInfo, "#{API_WAI_SEM}(#{sObjectID})", nil)
                else
                  cElement.set_syscall(hProcUnitInfo, "#{API_TWAI_SEM}(#{sObjectID}, #{cTaskInfo.hState[TSR_PRM_LEFTTMO].to_i + @nPreGainTick})", nil)
                end

              when TSR_OBJ_EVENTFLAG
                # ���ֻ��꤬����Х����ॢ�����դ�API����Ѥ���
                if (cTaskInfo.hState[TSR_PRM_LEFTTMO].nil?())
                  # �ѿ������ꤵ��Ƥ���л��Ѥ���
                  if (aWtskList[sTaskID][TSR_PRM_VAR] != nil)
                    cElement.set_syscall(hProcUnitInfo, "#{API_WAI_FLG}(#{sObjectID}, #{aWtskList[sTaskID][TSR_VAR_WAIPTN]}, #{aWtskList[sTaskID][TSR_VAR_WFMODE]}, &#{aWtskList[sTaskID][TSR_PRM_VAR]})", nil)
                  else
                    cElement.set_local_var(sTaskID, VAR_FLGPTN, TYP_FLGPTN)
                    cElement.set_syscall(hProcUnitInfo, "#{API_WAI_FLG}(#{sObjectID}, #{aWtskList[sTaskID][TSR_VAR_WAIPTN]}, #{aWtskList[sTaskID][TSR_VAR_WFMODE]}, &#{VAR_FLGPTN})", nil)
                  end
                else
                  # �ѿ������ꤵ��Ƥ���л��Ѥ���
                  if (aWtskList[sTaskID][TSR_PRM_VAR] != nil)
                    cElement.set_syscall(hProcUnitInfo, "#{API_TWAI_FLG}(#{sObjectID}, #{aWtskList[sTaskID][TSR_VAR_WAIPTN]}, #{aWtskList[sTaskID][TSR_VAR_WFMODE]}, &#{aWtskList[sTaskID][TSR_PRM_VAR]}, #{cTaskInfo.hState[TSR_PRM_LEFTTMO].to_i + @nPreGainTick})", nil)
                  else
                    cElement.set_local_var(sTaskID, VAR_FLGPTN, TYP_FLGPTN)
                    cElement.set_syscall(hProcUnitInfo, "#{API_TWAI_FLG}(#{sObjectID}, #{aWtskList[sTaskID][TSR_VAR_WAIPTN]}, #{aWtskList[sTaskID][TSR_VAR_WFMODE]}, &#{VAR_FLGPTN}, #{cTaskInfo.hState[TSR_PRM_LEFTTMO].to_i + @nPreGainTick})", nil)
                  end
                end

              when TSR_OBJ_MAILBOX
                # ���ֻ��꤬����Х����ॢ�����դ�API����Ѥ���
                if (cTaskInfo.hState[TSR_PRM_LEFTTMO].nil?())
                  # �ѿ������ꤵ��Ƥ���л��Ѥ���
                  if (!aWtskList[sTaskID].nil?())
                    cElement.set_syscall(hProcUnitInfo, "#{API_RCV_MBX}(#{sObjectID}, &#{aWtskList[sTaskID][TSR_PRM_VAR]})", nil)
                  else
                    cElement.set_local_var(sTaskID, VAR_P_MSG, TYP_T_P_MSG)
                    cElement.set_syscall(hProcUnitInfo, "#{API_RCV_MBX}(#{sObjectID}, &#{VAR_P_MSG})", nil)
                  end
                else
                  # �ѿ������ꤵ��Ƥ���л��Ѥ���
                  if (!aWtskList[sTaskID].nil?())
                    cElement.set_syscall(hProcUnitInfo, "#{API_TRCV_MBX}(#{sObjectID}, &#{aWtskList[sTaskID][TSR_PRM_VAR]}, #{cTaskInfo.hState[TSR_PRM_LEFTTMO].to_i + @nPreGainTick})", nil)
                  else
                    cElement.set_local_var(sTaskID, VAR_P_MSG, TYP_T_P_MSG)
                    cElement.set_syscall(hProcUnitInfo, "#{API_TRCV_MBX}(#{sObjectID}, &#{VAR_P_MSG}, #{cTaskInfo.hState[TSR_PRM_LEFTTMO].to_i + @nPreGainTick})", nil)
                  end
                end

              when TSR_OBJ_MEMORYPOOL
                # ���ֻ��꤬����Х����ॢ�����դ�API����Ѥ���
                if (cTaskInfo.hState[TSR_PRM_LEFTTMO].nil?())
                  # �ѿ������ꤵ��Ƥ���л��Ѥ���
                  if (!aWtskList[sTaskID].nil?())
                    cElement.set_syscall(hProcUnitInfo, "#{API_GET_MPF}(#{sObjectID}, &#{aWtskList[sTaskID][TSR_PRM_VAR]})", nil)
                  else
                    cElement.set_local_var(sTaskID, VAR_BLK, TYP_VOID_P)
                    cElement.set_syscall(hProcUnitInfo, "#{API_GET_MPF}(#{sObjectID}, &#{VAR_BLK})", nil)
                  end
                else
                  # �ѿ������ꤵ��Ƥ���л��Ѥ���
                  if (!aWtskList[sTaskID].nil?())
                    cElement.set_syscall(hProcUnitInfo, "#{API_TGET_MPF}(#{sObjectID}, &#{aWtskList[sTaskID][TSR_PRM_VAR]}, #{cTaskInfo.hState[TSR_PRM_LEFTTMO].to_i + @nPreGainTick})", nil)
                  else
                    cElement.set_local_var(sTaskID, VAR_BLK, TYP_VOID_P)
                    cElement.set_syscall(hProcUnitInfo, "#{API_TGET_MPF}(#{sObjectID}, &#{VAR_BLK}, #{cTaskInfo.hState[TSR_PRM_LEFTTMO].to_i + @nPreGainTick})", nil)
                  end
                end

              end

              if (cTaskInfo.hState[TSR_PRM_PRCID] == @sMainPrcid)
                # �ᥤ�󥿥�����ͥ���٤��᤹����Υ�����
                set_chg_pri(cElement)
              else
                cElement.set_state_sync(get_proc_unit_info(), hProcUnitInfo[:id], KER_TTS_WAI)
              end

              # �оݥ������θ���ͥ���٤Ƚ��ͥ���٤��ۤʤ��礳����chg_pri����
              # (Ʊ���̿����֥������Ȥ�°����ͥ���ٽ���ä����ˡ��Ԥ���Ǥʤ��Ƚ�����Ѥ���ǽ��������)
              if (cTaskInfo.hState[TSR_PRM_TSKPRI] != cTaskInfo.hState[TSR_PRM_ITSKPRI])
                cElement.set_syscall(hMainTaskInfo, "#{API_CHG_PRI}(#{cTaskInfo.sObjectID}, #{cTaskInfo.hState[TSR_PRM_TSKPRI]})")
              end

              cElement.set_block_delimiter()
            }
          }
        end

        # �����Ԥ��������Υꥹ��
        if (!cObjectInfo.hState[TSR_PRM_STSKLIST].nil?() && !cObjectInfo.hState[TSR_PRM_STSKLIST].empty?())
          cObjectInfo.hState[TSR_PRM_STSKLIST].each{|aStskList|
            aStskList.each{|sTaskID, hData|
              cTaskInfo = @hTask[sTaskID]

              # �оݥ������إǥ����ѥå����뤿��Υ�����
              set_act_task_fmp(cElement, cTaskInfo)

              # �оݥ������ξ�������������å��ݥ��������
              hProcUnitInfo = get_proc_unit_info(cTaskInfo)
              cElement.set_checkpoint(hProcUnitInfo)

              case cObjectInfo.sObjectType
              when TSR_OBJ_DATAQUEUE
                # ���ֻ��꤬����Х����ॢ�����դ�API����Ѥ���
                if (cTaskInfo.hState[TSR_PRM_LEFTTMO].nil?())
                  cElement.set_syscall(hProcUnitInfo, "#{API_SND_DTQ}(#{sObjectID}, #{hData[hData.keys[0]]})", nil)
                else
                  cElement.set_syscall(hProcUnitInfo, "#{API_TSND_DTQ}(#{sObjectID}, #{hData[hData.keys[0]]}, #{cTaskInfo.hState[TSR_PRM_LEFTTMO].to_i + @nPreGainTick})", nil)
                end

              when TSR_OBJ_P_DATAQUEUE
                # ���ֻ��꤬����Х����ॢ�����դ�API����Ѥ���
                if (cTaskInfo.hState[TSR_PRM_LEFTTMO].nil?())
                  cElement.set_syscall(hProcUnitInfo, "#{API_SND_PDQ}(#{sObjectID}, #{hData[TSR_VAR_DATA]}, #{hData[TSR_VAR_DATAPRI]})", nil)
                else
                  cElement.set_syscall(hProcUnitInfo, "#{API_TSND_PDQ}(#{sObjectID}, #{hData[TSR_VAR_DATA]}, #{hData[TSR_VAR_DATAPRI]}, #{cTaskInfo.hState[TSR_PRM_LEFTTMO].to_i + @nPreGainTick})", nil)
                end

              end

              if (cTaskInfo.hState[TSR_PRM_PRCID] == @sMainPrcid)
                # �ᥤ�󥿥�����ͥ���٤��᤹����Υ�����
                set_chg_pri(cElement)
              else
                cElement.set_state_sync(get_proc_unit_info(), hProcUnitInfo[:id], KER_TTS_WAI)
              end

              # �оݥ������θ���ͥ���٤Ƚ��ͥ���٤��ۤʤ��礳����chg_pri����
              # (Ʊ���̿����֥������Ȥ�°����ͥ���ٽ���ä����ˡ��Ԥ���Ǥʤ��Ƚ�����Ѥ���ǽ��������)
              if (cTaskInfo.hState[TSR_PRM_TSKPRI] != cTaskInfo.hState[TSR_PRM_ITSKPRI])
                cElement.set_syscall(hMainTaskInfo, "#{API_CHG_PRI}(#{cTaskInfo.sObjectID}, #{cTaskInfo.hState[TSR_PRM_TSKPRI]})")
              end

              cElement.set_block_delimiter()
            }
          }
        end

        # �����Ԥ��������Υꥹ��
        if (!cObjectInfo.hState[TSR_PRM_RTSKLIST].nil?() && !cObjectInfo.hState[TSR_PRM_RTSKLIST].empty?())
          cObjectInfo.hState[TSR_PRM_RTSKLIST].each{|aRtskList|
            aRtskList.each_key{|sTaskID|
              cTaskInfo = @hTask[sTaskID]

              # �оݥ������إǥ����ѥå����뤿��Υ�����
              set_act_task_fmp(cElement, cTaskInfo)

              # �оݥ������ξ�������������å��ݥ��������
              hProcUnitInfo = get_proc_unit_info(cTaskInfo)
              cElement.set_checkpoint(hProcUnitInfo)

              case cObjectInfo.sObjectType
              when TSR_OBJ_DATAQUEUE
                # ���ֻ��꤬����Х����ॢ�����դ�API����Ѥ���
                if (cTaskInfo.hState[TSR_PRM_LEFTTMO].nil?())
                  # �ѿ������ꤵ��Ƥ���л��Ѥ���
                  if (!aRtskList[sTaskID].nil?())
                    cElement.set_syscall(hProcUnitInfo, "#{API_RCV_DTQ}(#{sObjectID}, &#{aRtskList[sTaskID][TSR_PRM_VAR]})", nil)
                  else
                    cElement.set_local_var(sTaskID, VAR_DATA, TYP_INTPTR_T)
                    cElement.set_syscall(hProcUnitInfo, "#{API_RCV_DTQ}(#{sObjectID}, &#{VAR_DATA})", nil)
                  end
                else
                  if (!aRtskList[sTaskID].nil?())
                    cElement.set_syscall(hProcUnitInfo, "#{API_TRCV_DTQ}(#{sObjectID}, &#{aRtskList[sTaskID][TSR_PRM_VAR]}, #{cTaskInfo.hState[TSR_PRM_LEFTTMO].to_i + @nPreGainTick})", nil)
                  else
                    # �ѿ������ꤵ��Ƥ���л��Ѥ���
                    cElement.set_local_var(sTaskID, VAR_DATA, TYP_INTPTR_T)
                    cElement.set_syscall(hProcUnitInfo, "#{API_TRCV_DTQ}(#{sObjectID}, &#{VAR_DATA}, #{cTaskInfo.hState[TSR_PRM_LEFTTMO].to_i + @nPreGainTick})", nil)
                  end
                end

              when TSR_OBJ_P_DATAQUEUE
                # ���ֻ��꤬����Х����ॢ�����դ�API����Ѥ���
                if (cTaskInfo.hState[TSR_PRM_LEFTTMO].nil?())
                  # �ѿ������ꤵ��Ƥ���л��Ѥ���
                  if (!aRtskList[sTaskID].nil?())
                    cElement.set_syscall(hProcUnitInfo, "#{API_RCV_PDQ}(#{sObjectID}, &#{aRtskList[sTaskID][TSR_VAR_VARDATA]}, &#{aRtskList[sTaskID][TSR_VAR_VARPRI]})", nil)
                  else
                    cElement.set_local_var(sTaskID, VAR_DATA, TYP_INTPTR_T)
                    cElement.set_local_var(sTaskID, VAR_DATAPRI, TYP_PRI)
                    cElement.set_syscall(hProcUnitInfo, "#{API_RCV_PDQ}(#{sObjectID}, &#{VAR_DATA}, &#{VAR_DATAPRI})", nil)
                  end
                else
                  # �ѿ������ꤵ��Ƥ���л��Ѥ���
                  if (!aRtskList[sTaskID].nil?())
                    cElement.set_syscall(hProcUnitInfo, "#{API_TRCV_PDQ}(#{sObjectID}, &#{aRtskList[sTaskID][TSR_VAR_VARDATA]}, &#{aRtskList[sTaskID][TSR_VAR_VARPRI]}, #{cTaskInfo.hState[TSR_PRM_LEFTTMO].to_i + @nPreGainTick})", nil)
                  else
                    cElement.set_local_var(sTaskID, VAR_DATA, TYP_INTPTR_T)
                    cElement.set_local_var(sTaskID, VAR_DATAPRI, TYP_PRI)
                    cElement.set_syscall(hProcUnitInfo, "#{API_TRCV_PDQ}(#{sObjectID}, &#{VAR_DATA}, &#{VAR_DATAPRI}, #{cTaskInfo.hState[TSR_PRM_LEFTTMO].to_i + @nPreGainTick})", nil)
                  end
                end

              end

              if (cTaskInfo.hState[TSR_PRM_PRCID] == @sMainPrcid)
                # �ᥤ�󥿥�����ͥ���٤��᤹����Υ�����
                set_chg_pri(cElement)
              else
                cElement.set_state_sync(get_proc_unit_info(), hProcUnitInfo[:id], KER_TTS_WAI)
              end

              # �оݥ������θ���ͥ���٤Ƚ��ͥ���٤��ۤʤ��礳����chg_pri����
              # (Ʊ���̿����֥������Ȥ�°����ͥ���ٽ���ä����ˡ��Ԥ���Ǥʤ��Ƚ�����Ѥ���ǽ��������)
              if (cTaskInfo.hState[TSR_PRM_TSKPRI] != cTaskInfo.hState[TSR_PRM_ITSKPRI])
                cElement.set_syscall(hMainTaskInfo, "#{API_CHG_PRI}(#{cTaskInfo.sObjectID}, #{cTaskInfo.hState[TSR_PRM_TSKPRI]})")
              end

              cElement.set_block_delimiter()
            }
          }
        end
      }

      # �Ԥ����ֺ����塤�ᥤ�󥿥�������ä������ǥ����å��ݥ����
      cElement.set_checkpoint(get_proc_unit_info())

      return cElement # [IMCodeElement]Ʊ�����̿����֥������Ȥˤ���Ԥ����֥������ν�����֤����ꥳ����
    end


    #=================================================================
    # ��  ��: �Ԥ����֤Ǥ��륿�����ν�����֤����������
    #         IMCodeElement���饹�ˤޤȤ���֤�
    #=================================================================
    def gc_pre_task_waiting_fmp()
      cElement = IMCodeElement.new()

      @aTask.each{ |nPrcid, sObjectID, cObjectInfo|
        if (GRP_WAIT_NON_OBJECT.include?(cObjectInfo.hState[TSR_PRM_WOBJID]))
          # �оݥ������إǥ����ѥå����뤿��Υ�����
          set_act_task_fmp(cElement, cObjectInfo)

          # �оݥ������ξ�������������å��ݥ��������
          hProcUnitInfo = get_proc_unit_info(cObjectInfo)
          cElement.set_checkpoint(hProcUnitInfo)

          if (cObjectInfo.hState[TSR_PRM_WOBJID] == TSR_STT_SLEEP)
            if (cObjectInfo.hState[TSR_PRM_LEFTTMO].nil?())
              cElement.set_syscall(hProcUnitInfo, "#{API_SLP_TSK}()", nil)
            else
              cElement.set_syscall(hProcUnitInfo, "#{API_TSLP_TSK}(#{cObjectInfo.hState[TSR_PRM_LEFTTMO].to_i + @nPreGainTick})", nil)
            end
          elsif (cObjectInfo.hState[TSR_PRM_WOBJID] == TSR_STT_DELAY)
            cElement.set_syscall(hProcUnitInfo, "#{API_DLY_TSK}(#{cObjectInfo.hState[TSR_PRM_LEFTTMO].to_i + @nPreGainTick})", nil)
          end

          if (nPrcid == @sMainPrcid)
            # �ᥤ�󥿥�����ͥ���٤��᤹����Υ�����
            set_chg_pri(cElement)
          else
            cElement.set_state_sync(get_proc_unit_info(), hProcUnitInfo[:id], KER_TTS_WAI)
          end
          # �Ԥ����ֺ����塤�ᥤ�󥿥�������ä������ǥ����å��ݥ���Ȥȥ֥�å��ڤ�ʬ��
          cElement.set_checkpoint(get_proc_unit_info())
          cElement.set_block_delimiter()
        end
      }

      return cElement # [IMCodeElement]�������
    end


    #=================================================================
    # ��  ��: �ٻ߾��֤Ǥ��륿�����ν�����֤����������
    #         IMCodeElement���饹�ˤޤȤ���֤�
    #=================================================================
    def gc_pre_task_dormant_fmp()
      cElement      = IMCodeElement.new()
      hMainTaskInfo = get_proc_unit_info()

      @aTask.each{|nPrcid, sObjectID, cObjectInfo|
        if (cObjectInfo.hState[TSR_PRM_STATE] == KER_TTS_DMT)
          cElement.set_migrate_task(hMainTaskInfo, sObjectID, nPrcid)
        end
      }

      return cElement # [IMCodeElement]�ٻ߾��֤Ǥ��륿�����ν�����֤����ꥳ����
    end


    #=================================================================
    # ��  ��: �������֤Ǥ��륿�����ν�����֤����������
    #         IMCodeElement���饹�ˤޤȤ���֤�
    #=================================================================
    def gc_pre_task_suspended_fmp()
      # �ᥤ�󥿥�����sus_tsk(�оݥ�����)����
      cElement      = IMCodeElement.new()
      hMainTaskInfo = get_proc_unit_info()

      @aTask.each{|nPrcid, sObjectID, cObjectInfo|
        if (GRP_SUSPENDED.include?(cObjectInfo.hState[TSR_PRM_STATE]))  # TTS_SUS��TTS_WAS
          hProcUnitInfo = get_proc_unit_info(cObjectInfo)
          if (cObjectInfo.hState[TSR_PRM_STATE] == KER_TTS_SUS)
            # �оݥ������إǥ����ѥå����뤿��Υ�����
            set_act_task_fmp(cElement, cObjectInfo)

            # �оݥ������Υ����å��ݥ��������
            cElement.set_checkpoint(hProcUnitInfo)

            cElement.set_syscall(hProcUnitInfo, "#{API_SLP_TSK}()")

            if (nPrcid == @sMainPrcid)
              # �ᥤ�󥿥�����ͥ���٤��᤹����Υ�����
              set_chg_pri(cElement)
            else
              cElement.set_state_sync(hMainTaskInfo, sObjectID, KER_TTS_WAI)
            end
          end

          cElement.set_syscall(hMainTaskInfo, "#{API_SUS_TSK}(#{sObjectID})")

          # �����Ԥ��ξ�硤�������ƴ���
          if (cObjectInfo.hState[TSR_PRM_STATE] == KER_TTS_SUS)
            cElement.set_syscall(hMainTaskInfo, "#{API_WUP_TSK}(#{sObjectID})")
            # ������������ref���ʤ��褦�����Ԥ��Ȥʤä����Ȥ��ǧ����
            cElement.set_state_sync(hMainTaskInfo, sObjectID, KER_TTS_SUS)
          end
          # �Ԥ����ֺ����塤�ᥤ�󥿥�������ä������ǥ����å��ݥ���Ȥȥ֥�å��ڤ�ʬ��
          cElement.set_checkpoint(hMainTaskInfo)
          cElement.set_block_delimiter()
        end
      }

      return cElement # [IMCodeElement]�������֤Ǥ��륿�����ν�����֤����ꥳ����
    end

    #=================================================================
    # ��  ��: ��ǥ������֤Ǥ��륿�����ν�����֤����������
    #         IMCodeElement���饹�ˤޤȤ���֤�
    #=================================================================
    def gc_pre_task_ready_fmp()
      cElement      = IMCodeElement.new()
      hMainTaskInfo = get_proc_unit_info()

      # �ᥤ�󥿥������鵯�����ơ�����������slp_tsk���Ƥ���
      @aTask.each{|nPrcid, sObjectID, cObjectInfo|
        if (cObjectInfo.hState[TSR_PRM_STATE] == KER_TTS_RDY)
          # �оݥ������إǥ����ѥå����뤿��Υ�����
          set_act_task_fmp(cElement, cObjectInfo)

          # �оݥ������ξ�������������å��ݥ��������
          hProcUnitInfo = get_proc_unit_info(cObjectInfo)
          cElement.set_checkpoint(hProcUnitInfo)

          cElement.set_syscall(hProcUnitInfo, "#{API_SLP_TSK}()")

          if (nPrcid == @sMainPrcid)
            # �ᥤ�󥿥�����ͥ���٤��᤹����Υ�����
            set_chg_pri(cElement)
          else
            cElement.set_state_sync(get_proc_unit_info(), hProcUnitInfo[:id], KER_TTS_WAI)
          end
          # �ᥤ�󥿥�������ä������ǥ����å��ݥ���Ȥȥ֥�å��ڤ�ʬ��
          cElement.set_checkpoint(get_proc_unit_info())
          cElement.set_block_delimiter()
        end
      }

      return cElement # [IMCodeElement]��ǥ������֤Ǥ��륿�����ν�����֤����ꥳ����
    end

    #=================================================================
    # ��  ��: �¹Ծ��֤Ǥ��륿�������������㳰�ν�����֤����������
    #         IMCodeElement���饹�ˤޤȤ���֤�
    #=================================================================
    def gc_pre_task_running_texhdr_activate_fmp()
      # �¹Ծ��֤ˤʤ�٤��Υ�������ᥤ�󥿥������鵯����
      cElement      = IMCodeElement.new()
      hMainTaskInfo = get_proc_unit_info()

      # �ᥤ��ץ��å���Ǹ�����ꤹ��
      # (¾�ץ��å����¹Ծ��֤Ȥʤ����˥ᥤ�󤫤�ref����Τ��ɤ�)
      aPrcid = []
      @aPrcid.each{ |nPrcid|
        if (nPrcid != @sMainPrcid)
          aPrcid.push(nPrcid)
        end
      }
      aPrcid.push(@sMainPrcid)

      aPrcid.each{|nPrcid|
        if (!@aRunning[nPrcid].nil?())
          # �������ξ��
          if (@aRunning[nPrcid].sObjectType == TSR_OBJ_TASK)
            hProcUnitInfo = get_proc_unit_info(@aRunning[nPrcid])
            cElement.set_syscall(hMainTaskInfo, "#{API_MACT_TSK}(#{@aRunning[nPrcid].sObjectID}, #{@aRunning[nPrcid].hState[TSR_PRM_PRCID]})")
            # ��������α�㳰�װ�����������ꤹ��
            if (!@aRunning[nPrcid].cTex.nil?() && 
                !@aRunning[nPrcid].cTex.hState[TSR_PRM_PNDPTN].nil?() && 
                @aRunning[nPrcid].cTex.hState[TSR_PRM_PNDPTN] != 0 &&
                @aRunning[nPrcid].cTex.hState[TSR_PRM_HDLSTAT] != TSR_STT_ACTIVATE)
              cElement.set_syscall(hMainTaskInfo, "#{API_RAS_TEX}(#{@aRunning[nPrcid].sObjectID}, #{@aRunning[nPrcid].cTex.hState[TSR_PRM_PNDPTN]})")
            end

            # ����ͥ���٤Ƚ��ͥ���٤��ۤʤ�����ꤹ��
            if (@aRunning[nPrcid].hState[TSR_PRM_TSKPRI] != @aRunning[nPrcid].hState[TSR_PRM_ITSKPRI])
              cElement.set_syscall(hMainTaskInfo, "#{API_CHG_PRI}(#{@aRunning[nPrcid].sObjectID}, #{@aRunning[nPrcid].hState[TSR_PRM_TSKPRI]})")
            end

            # active_sync
            if (@aRunning[nPrcid].hState[TSR_PRM_PRCID] != @sMainPrcid)
              cElement.set_checkpoint(hProcUnitInfo)
              cElement.set_wait_check_sync(hMainTaskInfo, @aRunning[nPrcid].hState[TSR_PRM_PRCID])
            end

            cElement.set_block_delimiter()

          # �������㳰�ξ��
          else
            hRunningTask  = get_proc_unit_info(get_object_info(@aRunning[nPrcid].hState[TSR_PRM_TASK]))
            hActivateTex  = get_proc_unit_info(@aRunning[nPrcid])

            # �¹Ծ��֤Υ�������ư����
            cElement.set_syscall(hMainTaskInfo, "#{API_MACT_TSK}(#{@aRunning[nPrcid].hState[TSR_PRM_TASK]}, #{@aRunning[nPrcid].hState[TSR_PRM_PRCID]})")

            # �¹Ծ��֤Υ��������������㳰��ư����
            cElement.set_syscall(hRunningTask, "#{API_RAS_TEX}(#{TTG_TSK_SELF}, #{@aRunning[nPrcid].hState[TSR_PRM_TEXPTN]})")

            # �������㳰���ľ��֤�TTEX_DIS�ξ�硤ena_tex����ACTIVATE�ˤ���
            if (@aRunning[nPrcid].hState[TSR_PRM_STATE] == TSR_STT_TTEX_DIS)
              cElement.set_syscall(hRunningTask, "#{API_ENA_TEX}()")
            # �������㳰���ľ��֤�TTEX_ENA�ξ�硤����ena_tex���Ƥ��뤬���������㳰��ư��˺���ena_tex����
            else
              cElement.set_syscall(hActivateTex, "#{API_ENA_TEX}()")
            end

            # ��α�㳰�װ��ѥ�����0�Ǥʤ���硤��ʬ��ras_tex����
            if (@aRunning[nPrcid].hState[TSR_PRM_PNDPTN] != 0)
              cElement.set_syscall(hActivateTex, "#{API_RAS_TEX}(#{TTG_TSK_SELF}, #{@aRunning[nPrcid].hState[TSR_PRM_PNDPTN]})")
            end

            # active_sync
            if (@aRunning[nPrcid].hState[TSR_PRM_PRCID] != @sMainPrcid)
              cElement.set_checkpoint(hActivateTex)
              cElement.set_wait_check_sync(hMainTaskInfo, @aRunning[nPrcid].hState[TSR_PRM_PRCID])
            end

            cElement.set_block_delimiter()
          end
        end
      }

      return cElement # [IMCodeElement]�¹Ծ��֤Ǥ��륿�������������㳰�ν�����֤����ꥳ����
    end

    #=================================================================
    # ��  ��: ���Ͼ��֤Ǥ��륿�����ν�����֤����������
    #         IMCodeElement���饹�ˤޤȤ���֤�
    #=================================================================
    def gc_pre_task_running_suspended_fmp()
      cElement = IMCodeElement.new()

      @aTask.each{|nPrcid, sObjectID, cObjectInfo|
        if (cObjectInfo.hState[TSR_PRM_STATE] == KER_TTS_RUS)
          # ���Ͼ��֤Ǥ��륿�������Ȥ��鶯���Ԥ��ˤ�����
          hProcUnitInfo = get_proc_unit_info(@aActivate[nPrcid], @aRunning[nPrcid])
          cElement.set_syscall(hProcUnitInfo, "#{FNC_SUS_TSK}(#{sObjectID})")

          if (nPrcid == @sMainPrcid)
            cElement.set_block_delimiter()
          else
            # ¾�ץ��å��ξ�硤�ᥤ��ץ��å��μ¹Ծ��֤ν���ñ�̤����ǧ����
            cElement.set_state_sync(get_proc_unit_info(@cActivate, @cRunning), sObjectID, KER_TTS_RUS)
            cElement.set_block_delimiter()
          end
        end
      }

      return cElement # [IMCodeElement]���Ͼ��֤Ǥ��륿�����ν�����֤����ꥳ����
    end

    #=================================================================
    # ��  ��: ��ư����󥿥��������������
    #         IMCodeElement���饹�ˤޤȤ���֤�
    #=================================================================
    def gc_pre_nontask_activate_fmp()
      cElement      = IMCodeElement.new()
      hProcUnitInfo = get_proc_unit_info(@cRunning)

      # �ʤ��٤����֤��ݻ�����
      nGainTick = 0

      # �ᥤ��ץ��å���Ǹ�����ꤷ�ʤ����󥿥����ε�ư�ˤ�äƽ�����
      # ��³�Ǥ��ʤ��ʤ뤿�ᡤ�ᥤ��ץ��å���Ǹ�˰�ư������
      aPrcid = []
      @aPrcid.each{|nPrcid|
        if (nPrcid != @sMainPrcid)
          aPrcid.push(nPrcid)
        end
      }
      aPrcid.push(@sMainPrcid)

      aWaitPrcid = []
      aPrcid.each{|nPrcid|
        if (!@aActivate[nPrcid].nil?())
          case @aActivate[nPrcid].sObjectType
          # ���顼��ϥ�ɥ�
          when TSR_OBJ_ALARM
            # 0�ä����ꤷ��1�ߥ��ÿʤ��
            if (@cConf.is_timer_local?())
              cElement.set_syscall(hProcUnitInfo, "#{API_MSTA_ALM}(#{@aActivate[nPrcid].sObjectID}, 0, #{nPrcid})")
            else
              cElement.set_syscall(hProcUnitInfo, "#{API_STA_ALM}(#{@aActivate[nPrcid].sObjectID}, 0)")
            end
            # STA°��������м��Ȥ���ista_alm��¹Ԥ���
            if (@aActivate[nPrcid].hState[TSR_PRM_STATE] == TSR_STT_TALM_STA)
              cElement.set_syscall(get_proc_unit_info(@aActivate[nPrcid]), "#{API_ISTA_ALM}(#{@aActivate[nPrcid].sObjectID}, #{@aActivate[nPrcid].hState[TSR_PRM_LEFTTMO]})")
            end
            if (nGainTick < 1)
              nGainTick = 1
            end

          # �����ϥ�ɥ�
          when TSR_OBJ_CYCLE
            if (@cConf.is_timer_local?())
              cElement.set_syscall(hProcUnitInfo, "#{API_MSTA_CYC}(#{@aActivate[nPrcid].sObjectID}, #{nPrcid})")
            else
              cElement.set_syscall(hProcUnitInfo, "#{API_STA_CYC}(#{@aActivate[nPrcid].sObjectID})")
            end
            # �����ʬ�������֤�ʤ��
            if (nGainTick < @aActivate[nPrcid].hState[TSR_PRM_CYCPHS].to_i + 1)
              nGainTick = @aActivate[nPrcid].hState[TSR_PRM_CYCPHS].to_i + 1
            end

          # ����ߥϥ�ɥ顤����ߥ����ӥ��롼����
          when TSR_OBJ_INTHDR, TSR_OBJ_ISR
            # ����ߥϥ�ɥ顤����ߥ����ӥ��롼���󤬵�ư���Ƥ���ץ��å��Ǽ¹���ν���ñ�̤����
            cObjectInfo = aRunning[@aActivate[nPrcid].hState[TSR_PRM_PRCID]]
            hObjectInfo = get_proc_unit_info(cObjectInfo)
            # �����ȯ���ؿ���¹Ԥ��Ƶ�ư����
            cElement.set_code(hObjectInfo, "#{FNC_INT_RAISE}(#{@aActivate[nPrcid].hState[TSR_PRM_INTNO]})")

          # CPU�㳰�ϥ�ɥ�
          when TSR_OBJ_EXCEPTION
            # CPU�㳰����ư���Ƥ���ץ��å��Ǽ¹���ν���ñ�̤����
            cObjectInfo = aRunning[@aActivate[nPrcid].hState[TSR_PRM_PRCID]]
            hObjectInfo = get_proc_unit_info(cObjectInfo)
            # CPU�㳰ȯ���ؿ���¹Ԥ��Ƶ�ư����
            cElement.set_code(hObjectInfo, "#{FNC_CPUEXC_RAISE}(#{@aActivate[nPrcid].hState[TSR_PRM_EXCNO]})")

          else
            abort(ERR_MSG % [__FILE__, __LINE__])
          end

          # ��ư��ǧ�ѥ����å��ݥ����
          if (nPrcid != @sMainPrcid)
            cElement.set_checkpoint(get_proc_unit_info(@aActivate[nPrcid]))
            aWaitPrcid.push(nPrcid)
          end
        end
      }

      # �����륿���������ξ�硤¾�ץ��å��λ��֤��ʤ�Ǥ���ᥤ��ץ��å���ʤ��
      if (@cConf.is_timer_local?())
        # ¾�ץ��å���ACTIVATE���󥿥�����¸�ߤ�����
        if (!aWaitPrcid.empty?())
          (1..nGainTick).each{|nCnt|
            if (nCnt == nGainTick)
              # ¾�ץ��å��λ��֤�ʤ�Ƶ�ư����
              gc_tick_gain_local_other_fmp(cElement, aWaitPrcid)
              # �ᥤ��ץ��å��Ǽ¹���Υ������ǵ�ư�������Ȥ��Ԥ�
              aWaitPrcid.each{|nPrcid|
                cElement.set_wait_check_sync(hProcUnitInfo, nPrcid)
              }
              # �ᥤ��ץ��å��λ��֤�ʤ�Ƶ�ư����
              gc_tick_gain_local_main_fmp(cElement)
            else
              # ����λ��֤ϡ���礷�ƿʤ��
              gc_tick_gain_local_all_fmp(cElement)
            end
          }
        else
          # �ᥤ�󥿥����Τߤξ��ϡ���礷�ƻ��֤�ʤ��
          nGainTick.times{
            gc_tick_gain_local_all_fmp(cElement)
          }
        end
      # �����Х륿���������ϥ�����ƥ��å��ζ���Τ߹Ԥ�
      else
        nGainTick.times{
          gc_tick_gain_global_fmp(cElement, aWaitPrcid)
        }

        # ¾�ץ��å���ACTIVATE���󥿥�����ᥤ��ץ��å��Ǽ¹���Υ������ǵ�ư�������Ȥ��Ԥ�
        if (!aWaitPrcid.empty?())
          aWaitPrcid.each{|nPrcid|
            cElement.set_wait_check_sync(hProcUnitInfo, nPrcid)
          }
        end
      end

      return cElement # [IMCodeElement]��ư����󥿥��������ꥳ����
    end


    #=================================================================
    # ��  ��: �ǥ����ѥå��ػߤˤ����������
    #         IMCodeElement���饹�ˤޤȤ���֤�
    #=================================================================
    def gc_pre_dis_dsp_fmp()
      cElement = IMCodeElement.new()

      @aPrcid.each{ |nPrcid|
        if (@aRunning[nPrcid] != nil)
          if (!@aCpuState[nPrcid].nil?() && !@aCpuState[nPrcid].hState[TSR_PRM_DISDSP].nil?() && (@aCpuState[nPrcid].hState[TSR_PRM_DISDSP] == true))
            hProcUnitInfo = get_proc_unit_info(@aRunning[nPrcid])
            cElement.set_syscall(hProcUnitInfo, "#{API_DIS_DSP}()")
          end
        end
      }

      return cElement # [IMCodeElement]�ǥ����ѥå��ػߤˤ��������������
    end


    #=================================================================
    # ��  ��: �����ͥ���٥ޥ�����0�ʳ��ˤ����������
    #         IMCodeElement���饹�ˤޤȤ���֤�
    #=================================================================
    def gc_pre_set_ipm_fmp()
      cElement = IMCodeElement.new()

      @aPrcid.each{ |nPrcid|
        # �����ͥ���٥ޥ��������ꤵ��Ƥ�����Τ�
        if (!@aCpuState[nPrcid].nil?() &&
            !@aCpuState[nPrcid].hState[TSR_PRM_CHGIPM].nil?() &&
            (@aCpuState[nPrcid].hState[TSR_PRM_CHGIPM] != 0) && (@aCpuState[nPrcid].hState[TSR_PRM_CHGIPM] != KER_TIPM_ENAALL))

          # �ʲ��Τ����줫�����������Τ߳����ͥ���٥ޥ������ѹ�����
          # 1)ACTIVATE���󥿥�����¸�ߤ��ʤ�
          # 2)ACTIVATE���󥿥�����CPU�㳰�ϥ�ɥ�Ǥ���
          if (@aActivate[nPrcid].nil?() || (@aActivate[nPrcid].sObjectType == TSR_OBJ_EXCEPTION))
            hProcUnitInfo = get_proc_unit_info(@aRunning[nPrcid])
            cElement.set_syscall(hProcUnitInfo, "#{API_CHG_IPM}(#{@aCpuState[nPrcid].hState[TSR_PRM_CHGIPM]})")
          end
        end
      }

      return cElement # [IMCodeElement]�����ͥ���٥ޥ�����0�ʳ��ˤ��������������
    end


    #=================================================================
    # ��  ��: ���Ū��SLEEP�ޤ���DELAY��������������¹Խ��֤˵�����
    #         ������IMCodeElement���饹�ˤޤȤ���֤�
    #=================================================================
    def gc_pre_task_ready_porder_fmp()
      # ������꡼�פ����Ƥ�������������porder���ǧ����
      # �¹Բ�ǽ���֤ˤ�����

      # �¹Ծ��֤Υ�������������  ���¹Ծ��֤Υ�������������
      # �¹Ծ��֤Υ����������ʤ���硧�󥿥�����������
      cElement  = IMCodeElement.new()  # element���饹���Ѱդ���

      aPriorityTemp = []  # ͥ���̤Τʤ����������ݻ����뤿�������
      aPriOrderTemp = []  # ͥ���̤Τ��륿���������ݻ����뤿�������

      @aTask.each{|nPrcid, sObjectID, cObjectInfo|
        if (cObjectInfo.hState[TSR_PRM_STATE] == KER_TTS_RDY)
          nPOrder = cObjectInfo.hState[TSR_PRM_PORDER]

          if (aPriorityTemp[nPrcid].nil?())
            aPriorityTemp[nPrcid] = []
          end
          if (aPriOrderTemp[nPrcid].nil?())
            aPriOrderTemp[nPrcid] = []
          end

          if (nPOrder.nil?())
            aPriorityTemp[nPrcid].push(sObjectID)
          else
            aPriOrderTemp[nPrcid][nPOrder] = sObjectID  # ͥ���̤ν������
          end
        end
      }

      aPriOrderTemp.each{ |aPriPrc|
        if (!aPriPrc.nil?())
          aPriPrc.delete(nil)  # ɬ�פǤϤʤ�nil�Ϻ��
        end
      }

      @aPrcid.each{ |nPrcid|
        if (!aPriorityTemp[nPrcid].nil?())
          aPriOrderTemp[nPrcid].concat(aPriorityTemp[nPrcid])
        end
      }

      hProcUnitInfo = get_proc_unit_info(@cActivate, @cRunning)
      aPriOrderTemp.each{|aPriPrc|
        if (!aPriPrc.nil?())
          aPriPrc.each{|sObjectID|
            if (!@cActivate.nil?())
              cElement.set_syscall(hProcUnitInfo, "#{API_IWUP_TSK}(#{sObjectID})")
            else
              cElement.set_syscall(hProcUnitInfo, "#{API_WUP_TSK}(#{sObjectID})")
            end
          }
        end
      }

      cElement.set_checkpoint(hProcUnitInfo)

      return cElement # [IMCodeElement]���Ū��SLEEP�ޤ���DELAY��������������¹Խ��֤˵���������������
    end


    #=================================================================
    # ��  ��: ��ư�������׵ᥭ�塼���󥰤�����򤹤������
    #         IMCodeElement���饹�ˤޤȤ���֤�
    #=================================================================
    def gc_pre_task_queueing_fmp()
      cElement      = IMCodeElement.new()  # element���饹���Ѱդ���
      hProcUnitInfo = get_proc_unit_info(@cActivate, @cRunning)

      @aTask.each{|nPrcid, sObjectID, cObjectInfo|
        # ��ư�׵ᥭ�塼���󥰤�FMP�Ǥ�1����
        if (!cObjectInfo.hState[TSR_PRM_ACTCNT].nil?() && cObjectInfo.hState[TSR_PRM_ACTCNT] == 1)
          # ������եץ��å�ID�������mact_tsk�����ꤹ��
          if (!cObjectInfo.hState[TSR_PRM_ACTPRC].nil?())
            if (!@cActivate.nil?())
              cElement.set_syscall(hProcUnitInfo, "#{API_IMACT_TSK}(#{sObjectID}, #{cObjectInfo.hState[TSR_PRM_ACTPRC]})")
            else
              cElement.set_syscall(hProcUnitInfo, "#{API_MACT_TSK}(#{sObjectID}, #{cObjectInfo.hState[TSR_PRM_ACTPRC]})")
            end
          else
            if (!@cActivate.nil?())
              cElement.set_syscall(hProcUnitInfo, "#{API_IACT_TSK}(#{sObjectID})")
            else
              cElement.set_syscall(hProcUnitInfo, "#{API_ACT_TSK}(#{sObjectID})")
            end
          end
        end

        if(!cObjectInfo.hState[TSR_PRM_WUPCNT].nil?() && cObjectInfo.hState[TSR_PRM_WUPCNT] >= 1)
          cObjectInfo.hState[TSR_PRM_WUPCNT].times{
            if (!@cActivate.nil?())
              cElement.set_syscall(hProcUnitInfo, "#{API_IWUP_TSK}(#{sObjectID})")
            else
              cElement.set_syscall(hProcUnitInfo, "#{API_WUP_TSK}(#{sObjectID})")
            end
          }
        end
      }

      cElement.set_checkpoint(hProcUnitInfo)

      return cElement # [IMCodeElement]��ư�������׵ᥭ�塼���󥰤�����򤹤����������
    end


    #=================================================================
    # ��  ��: �����Υ����।�٥�ȥϥ�ɥ�����ꤹ�륳���ɤ��֤�
    #=================================================================
    def gc_pre_time_event_stp_other_fmp()
      cElement      = IMCodeElement.new()
      hMainTaskInfo = get_proc_unit_info()
      bFlg = false

      # ������եץ��å����ᥤ��ץ��å��Ǥʤ�������������Χ�ޥ����졼�Ȥ���
      @hAllObject.each{|sObjectID, cObjectInfo|
        if ((GRP_TIME_EVENT_HDL.include?(cObjectInfo.sObjectType) == true) &&
            (GRP_TIME_EVENT_STP.include?(cObjectInfo.hState[TSR_PRM_STATE]) == true) &&
            (cObjectInfo.hState[TSR_PRM_HDLSTAT] == TSR_STT_STP))
          if (cObjectInfo.sObjectType == TSR_OBJ_ALARM)
            cElement.set_syscall(hMainTaskInfo, "#{API_MSTA_ALM}(#{sObjectID}, #{TTG_ENOUGH_MIG_TIME}, #{cObjectInfo.hState[TSR_PRM_PRCID]})")
            cElement.set_syscall(hMainTaskInfo, "#{API_STP_ALM}(#{sObjectID})")
          elsif (cObjectInfo.sObjectType == TSR_OBJ_CYCLE)
            cElement.set_syscall(hMainTaskInfo, "#{API_MSTA_CYC}(#{sObjectID}, #{cObjectInfo.hState[TSR_PRM_PRCID]})")
            cElement.set_syscall(hMainTaskInfo, "#{API_STP_CYC}(#{sObjectID})")
          end

          bFlg = true
        end
      }

      cElement.set_checkpoint(hMainTaskInfo)

      if (bFlg == false)
        return nil # [nil]�ɲä�ɬ�פʤ�
      else
        return cElement # [IMCodeElement]�����Υ����।�٥�ȥϥ�ɥ�����ꤹ�륳����
      end
    end


    #=================================================================
    # ��  ��: ư�����(Txxx_STA)�Υ����।�٥�ȥϥ�ɥ�����ꤹ��
    #         �����ɤ��֤�
    #=================================================================
    def gc_pre_time_event_sta_fmp()
      cElement      = IMCodeElement.new()
      hMainTaskInfo = get_proc_unit_info()

      @hAllObject.each{|sObjectID, cObjectInfo|
        if ((GRP_TIME_EVENT_HDL.include?(cObjectInfo.sObjectType) == true) &&
            (GRP_TIME_EVENT_STA.include?(cObjectInfo.hState[TSR_PRM_STATE]) == true) &&
            (cObjectInfo.hState[TSR_PRM_HDLSTAT] != TSR_STT_ACTIVATE))
          if (cObjectInfo.sObjectType == TSR_OBJ_ALARM)
            if (@cConf.is_timer_local?())
              cElement.set_syscall(hMainTaskInfo, "#{API_MSTA_ALM}(#{sObjectID}, #{cObjectInfo.hState[TSR_PRM_LEFTTMO].to_i + @nPreGainTick}, #{cObjectInfo.hState[TSR_PRM_PRCID]})")
            else
              cElement.set_syscall(hMainTaskInfo, "#{API_STA_ALM}(#{sObjectID}, #{cObjectInfo.hState[TSR_PRM_LEFTTMO].to_i + @nPreGainTick})")
            end
          elsif (cObjectInfo.sObjectType == TSR_OBJ_CYCLE)
            if (@cConf.is_timer_local?())
              cElement.set_syscall(hMainTaskInfo, "#{API_MSTA_CYC}(#{sObjectID}, #{cObjectInfo.hState[TSR_PRM_PRCID]})")
            else
              cElement.set_syscall(hMainTaskInfo, "#{API_STA_CYC}(#{sObjectID})")
            end
          end
        end
      }

      cElement.set_checkpoint(hMainTaskInfo)

      return cElement # [IMCodeElement]ư�����(Txxx_STA)�Υ����।�٥�ȥϥ�ɥ�����ꤹ�륳����
    end


    #=================================================================
    # ��  ��: ���ԥ��å����֤�����(���ꤵ�줿����ñ�̤�������)������
    #         IMCodeElement���饹�ˤޤȤ���֤�
    #=================================================================
    def gc_pre_spin_loc_fmp()
      cElement = IMCodeElement.new()

      # �ᥤ��ץ��å�������λ��ǧ�ѥ����å��ݥ����
      cElement.set_checkpoint(get_proc_unit_info(@cActivate, @cRunning))
      bFlg = false

      @hAllObject.each{|sObjectID, cObjectInfo|
        if ((cObjectInfo.sObjectType == TSR_OBJ_SPINLOCK) && (cObjectInfo.hState[TSR_PRM_SPNSTAT] == TSR_STT_TSPN_LOC))
          cObject = get_object_info(cObjectInfo.hState[TSR_PRM_PROCID])
          hProcUnitInfo = get_proc_unit_info(cObject)

          # �ᥤ��ץ��å���¾�ν�����λ�������Ȥ��ԤäƤ����å�����
          # (CPU��å��Ȥʤ�Ȼ��֤��ʤ���ʤ�)
          cElement.set_wait_check_sync(hProcUnitInfo, @sMainPrcid)

          if (GRP_NON_CONTEXT.include?(cObject.sObjectType))
            cElement.set_syscall(hProcUnitInfo, "#{API_ILOC_SPN}(#{sObjectID})")
          else
            cElement.set_syscall(hProcUnitInfo, "#{API_LOC_SPN}(#{sObjectID})")
          end
          cElement.set_checkpoint(hProcUnitInfo)

          # ¾�ץ��å��ξ�硤���ԥ��å�������������Ȥ�ᥤ��ץ��å��Ǥ��Ԥ�
          # (���ref�����Τ��ɤ�)
          if (cObject.hState[TSR_PRM_PRCID] != @sMainPrcid)
            cElement.set_wait_check_sync(get_proc_unit_info(@cActivate, @cRunning), cObject.hState[TSR_PRM_PRCID])
          end

          # CPU��å����ʣ���Ƽ¹Ԥ��ʤ����ᡤ�ݻ����Ƥ���
          @aSpinProcID.push(cObject.sObjectID)

          bFlg = true
        end
      }

      if (bFlg == false)
        return nil # [nil]�ɲä�ɬ�פʤ�
      else
        return cElement # [IMCodeElement]���ԥ��å����֤�����(���ꤵ�줿����ñ�̤�������)����������
      end
    end


    #=================================================================
    # ��  ��: CPU��å����֤�����(�¹���ν���ñ�̤�������)������
    #         IMCodeElement���饹�ˤޤȤ���֤�
    #=================================================================
    def gc_pre_cpu_loc_fmp()
      # ��ư���֤��󥿥����������硤���顼�ࡦ�����ϥ�ɥ�ξ��
      # ������ϥ��顼��ˤ�����
      # �ޤ�����ư���֤��󥿥��������ʤ������ļ¹Ծ��֤Υ�������
      # ������ϡ��������ˤ�����

      cElement = IMCodeElement.new()

      # �ᥤ��ץ��å�������λ��ǧ�ѥ����å��ݥ����
      cElement.set_checkpoint(get_proc_unit_info(@cActivate, @cRunning))
      bFlg = false

      @aPrcid.each{ |nPrcid|
        # check�������ͤƹԤ�
        if (!@aCpuState[nPrcid].nil?() && !@aCpuState[nPrcid].hState[TSR_PRM_LOCCPU].nil?() && (@aCpuState[nPrcid].hState[TSR_PRM_LOCCPU] == true))
          hProcUnitInfo = get_proc_unit_info(@aActivate[nPrcid], @aRunning[nPrcid])

          # ���ԥ��å��ˤ��CPU��å��Ͻ���
          if (!@aSpinProcID.include?(hProcUnitInfo[:id]))
            # �ᥤ��ץ��å���¾�ν�����λ�������Ȥ��ԤäƤ����å�����
            # (CPU��å��Ȥʤ�Ȼ��֤��ʤ���ʤ�)
            cElement.set_wait_check_sync(hProcUnitInfo, @sMainPrcid)
            bFlg = true

            if (!@aActivate[nPrcid].nil?())
              cElement.set_syscall(hProcUnitInfo, "#{API_ILOC_CPU}()")
            else
              cElement.set_syscall(hProcUnitInfo, "#{API_LOC_CPU}()")
            end
            cElement.set_checkpoint(hProcUnitInfo)
          end
        end
      }

      if (bFlg == false)
        return nil # [nil]�ɲä�ɬ�פʤ�
      else
        return cElement # [IMCodeElement]CPU��å����֤�����(�¹���ν���ñ�̤�������)����
      end
    end

    #=================================================================
    # ��  ��: ���ľ��֤γ���ߤ����ꤹ�륳���ɤ��֤�
    #=================================================================
    def gc_pre_interrupt_ena_fmp()
      cElement      = IMCodeElement.new()
      hMainTaskInfo = get_proc_unit_info()

      # ena_int����ɬ�פΤ��������ֹ�ȥץ��å�ID�����
      aEnaIntNoID = []
      @hAllObject.each{|sObjectID, cObjectInfo|
        if ((GRP_INTERRUPT.include?(cObjectInfo.sObjectType) == true) &&
            (cObjectInfo.hState[TSR_PRM_STATE] == KER_TA_ENAINT))
          aEnaIntNoID.push([cObjectInfo.hState[TSR_PRM_INTNO], cObjectInfo.hState[TSR_PRM_PRCID]])
        end
      }

      # ��ʣ�������Ƥ��٤�ena_int��¹Ԥ���
      nMainPrcid = @sMainPrcid
      aEnaIntNoID.uniq!()
      aEnaIntNoID.each{|snIntNoID|
        # �ᥤ�󥿥������о�IntHdr/ISR�Υץ��å����ۤʤ���ϥᥤ�󥿥������ư
        if (nMainPrcid != snIntNoID[1])
          cElement.set_syscall(hMainTaskInfo, "#{API_MIG_TSK}(#{TTG_TSK_SELF}, #{snIntNoID[1]})")
          nMainPrcid = snIntNoID[1]
        end

        cElement.set_syscall(hMainTaskInfo, "#{API_ENA_INT}(#{snIntNoID[0]})")
      }

      # �Ǹ��ɬ���ᥤ��ץ��å������
      if (nMainPrcid != @sMainPrcid)
        cElement.set_syscall(hMainTaskInfo, "#{API_MIG_TSK}(#{TTG_TSK_SELF}, #{@sMainPrcid})")
      end

      cElement.set_checkpoint(hMainTaskInfo)

      return cElement # [IMCodeElement]���ľ��֤γ���ߤ����ꤹ�륳����
    end

  end
end
