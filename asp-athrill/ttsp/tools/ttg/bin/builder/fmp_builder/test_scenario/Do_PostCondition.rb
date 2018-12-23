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
#  $Id: Do_PostCondition.rb 14 2012-11-05 09:28:16Z nces-shigihara $
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
    # ��  ��: Do�ν�����IMCodeElement���饹�ˤޤȤ���֤�
    #=================================================================
    def gc_do_fmp(aPrevObjectInfo)
      check_class(Array, aPrevObjectInfo)  # ���Υ���ǥ������Υ��֥������Ⱦ���

      cElement        = IMCodeElement.new()
      cCallObjectInfo = nil
      # id�˵��ܤ���ID�Ȱ��פ��Ƥ������ñ�̤��������
      aPrevObjectInfo.each{ |cObjectInfo|
        if (!cObjectInfo.nil?())
          if (cObjectInfo.sObjectID == @hDo[TSR_PRM_ID])
            cCallObjectInfo = cObjectInfo
          end
        end
      }
      if (cCallObjectInfo.nil?())
        abort(ERR_MSG % [__FILE__, __LINE__])
      end

      hProcUnitInfo = get_proc_unit_info(cCallObjectInfo)

      # �����Ƚ���
      cElement.set_comment(hProcUnitInfo, "#{TSR_UNS_DO}#{@nSeqNum}_#{@nTimeTick}")
      # GCOV�����γ��Ϥ⤷���ϺƳ�
      gc_gcov_resume(cElement, hProcUnitInfo)
      # �оݤν���ñ�̤��󥿥�����Ʊ���������ʤ�����������
      # resume/pause�ν��Ʊ���Τ���Υ����å��ݥ���Ȥ�ȯ�Ԥ��Ƥ���
      if (@cConf.enable_gcov?() && @hDo[TSR_PRM_GCOV] == true)
        cElement.set_checkpoint(hProcUnitInfo)
      end

      # syscall��
      bIsReturn = true
      if (@hDo.has_key?(TSR_PRM_SYSCALL))
        if (@hDo.has_key?(TSR_PRM_ERCD))
          cElement.set_syscall(hProcUnitInfo, @hDo[TSR_PRM_SYSCALL], @hDo[TSR_PRM_ERCD])
        elsif (@hDo.has_key?(TSR_PRM_ERUINT))
          cElement.set_syscall(hProcUnitInfo, @hDo[TSR_PRM_SYSCALL], @hDo[TSR_PRM_ERUINT], TYP_ER_UINT)
        elsif (@hDo.has_key?(TSR_PRM_BOOL))
          cElement.set_syscall(hProcUnitInfo, @hDo[TSR_PRM_SYSCALL], @hDo[TSR_PRM_BOOL], TYP_BOOL_T)
        else
          cElement.set_syscall(hProcUnitInfo, @hDo[TSR_PRM_SYSCALL], nil)
          bIsReturn = false
        end
      else
        # "#"����Ϥޤ륳���ɤϥ��ߥ�������Ϳ���ʤ�
        bSemicolon = true
        if (@hDo[TSR_PRM_CODE] =~ /^\#.*/)
          bSemicolon = false
        end
        cElement.set_code(hProcUnitInfo, @hDo[TSR_PRM_CODE], bSemicolon)
        bIsReturn = false
      end

      # GCOV����������
      # ����ͤ������硤������¹Ծ��֤ˤʤ뤿��API��ȯ�Ԥ�������ñ�̤ǹԤ�
      @nGcovAfterSyncFlg = false
      if (bIsReturn == true)
        gc_gcov_pause(cElement, hProcUnitInfo)
      # resume��ȯ�Ԥ����ץ��å��˼��Υ���ǥ������Ǽ¹���ν���ñ�̤������
      # ���ν���ñ�̤�GCOV�����Ǥ���
      elsif (!@aActivate[hProcUnitInfo[:prcid]].nil?() || !@aRunning[hProcUnitInfo[:prcid]].nil?())
        gc_gcov_pause(cElement, get_proc_unit_info(@aActivate[hProcUnitInfo[:prcid]], @aRunning[hProcUnitInfo[:prcid]]))
      else
        # ����ͤ�̵���¹Ծ��֤ν���ñ�̤⤤�ʤ���硤Ʊ�������θ�˥ᥤ��ץ��å��Ǽ¹���ν���ñ�̤���Ԥ�
        # ���������оݤν���ñ�̤��󥿥�����Ʊ���������ʤ�����������
        # resume/pause�ν��Ʊ���Τ���Υ����å��ݥ�����Ԥ��Ȥ��Ƥ���
        if (@cConf.enable_gcov?() && @hDo[TSR_PRM_GCOV] == true)
          cElement.set_wait_check_sync(get_proc_unit_info(@cActivate, @cRunning), hProcUnitInfo[:prcid])
          # Ʊ�����pause����ɬ�פ����뤫���ݻ����Ƥ���
          @nGcovAfterSyncFlg = true
        end
      end

      return cElement  # [IMCodeElement]Do�ν���
    end

    #=================================================================
    # ��  ��: Ʊ���������gcov_pause�ѥ����ɤ����������֤�
    #=================================================================
    def gc_gcov_pause_after_sync()
      cElement = IMCodeElement.new()

      # pause��¹Ԥ��Ƥ��ʤ���硤Ʊ�������θ�Ǽ¹���ν���ñ�̤���Ԥ�
      if (@nGcovAfterSyncFlg == true)
        gc_gcov_pause(cElement, get_proc_unit_info(@cActivate, @cRunning))
      end

      return cElement  # [IMCodeElement]Ʊ���������gcov_pause�ѥ�����
    end

    #=================================================================
    # ��  ��: �ǥ����ѥå��ػ߾��֤������������
    #         IMCodeElement���饹�ˤޤȤ���֤�
    #=================================================================
    def gc_lastpost_ena_dsp_fmp()
      cElement      = IMCodeElement.new()
      @aPrcid.each{ |nPrcid|
        # check�������ͤƹԤ�
        if (!@aCpuState[nPrcid].nil?() && !@aCpuState[nPrcid].hState[TSR_PRM_DISDSP].nil?() && (@aCpuState[nPrcid].hState[TSR_PRM_DISDSP] == true))
          hProcUnitInfo = get_proc_unit_info(@aRunning[nPrcid])
          cElement.set_syscall(hProcUnitInfo, "#{API_ENA_DSP}()")
        end
      }

      return cElement  # [IMCodeElement]�ǥ����ѥå��ػ߾��֤����������
    end

    #=================================================================
    # ��  ��: �����ͥ���٥ޥ��������������������
    #         IMCodeElement���饹�ˤޤȤ���֤�
    #=================================================================
    def gc_lastpost_set_ini_ipm_fmp()
      cElement      = IMCodeElement.new()
      @aPrcid.each{ |nPrcid|
        # check�������ͤƹԤ�
        if (!@aCpuState[nPrcid].nil?() && !@aCpuState[nPrcid].hState[TSR_PRM_CHGIPM].nil?() && 
            (@aCpuState[nPrcid].hState[TSR_PRM_CHGIPM] != 0) && (@aCpuState[nPrcid].hState[TSR_PRM_CHGIPM] != KER_TIPM_ENAALL))
          hProcUnitInfo = get_proc_unit_info(@aRunning[nPrcid])
          cElement.set_syscall(hProcUnitInfo, "#{API_CHG_IPM}(#{KER_TIPM_ENAALL})")
        end
      }

      return cElement  # [IMCodeElement]�����ͥ���٥ޥ������������������
    end

    #=================================================================
    # ��  ��: ���ԥ��å������ν�����
    #         IMCodeElement���饹�ˤޤȤ���֤�
    #=================================================================
    def gc_lastpost_spin_unl_fmp()
      cElement = IMCodeElement.new()

      @hAllObject.each{|sObjectID, cObjectInfo|
        if ((cObjectInfo.sObjectType == TSR_OBJ_SPINLOCK) && (cObjectInfo.hState[TSR_PRM_SPNSTAT] == TSR_STT_TSPN_LOC))
          cObject = get_object_info(cObjectInfo.hState[TSR_PRM_PROCID])
          hProcUnitInfo = get_proc_unit_info(cObject)
          if (GRP_NON_CONTEXT.include?(cObject.sObjectType))
            cElement.set_syscall(hProcUnitInfo, "#{API_IUNL_SPN}(#{sObjectID})")
          else
            cElement.set_syscall(hProcUnitInfo, "#{API_UNL_SPN}(#{sObjectID})")
          end

          # CPU��å�������ʣ���Ƽ¹Ԥ��ʤ����ᡤ�ݻ����Ƥ���
          @aSpinProcID.push(cObject.sObjectID)
        end
      }

      return cElement  # [IMCodeElement]���ԥ��å������ν���
    end

    #=================================================================
    # ��  ��: CPU��å����֤β���ν�����
    #         IMCodeElement���饹�ˤޤȤ���֤�
    #=================================================================
    def gc_lastpost_cpu_unl_fmp()
      cElement = IMCodeElement.new()
      @aPrcid.each{ |nPrcid|
        # check�������ͤƹԤ�
        unless (@aCpuState[nPrcid].nil?() || @aCpuState[nPrcid].hState[TSR_PRM_LOCCPU].nil?() || (@aCpuState[nPrcid].hState[TSR_PRM_LOCCPU] != true))
          hProcUnitInfo = get_proc_unit_info(@aActivate[nPrcid], @aRunning[nPrcid])
          # ���ԥ��å��ˤ��CPU��å��Ͻ���
          if (!@aSpinProcID.include?(hProcUnitInfo[:id]))
            if (!@aActivate[nPrcid].nil?())
              cElement.set_syscall(hProcUnitInfo, "#{API_IUNL_CPU}()")
            else
              cElement.set_syscall(hProcUnitInfo, "#{API_UNL_CPU}()")
            end
          end
        end
      }

      return cElement  # [IMCodeElement]CPU��å����֤β���ν���
    end

    #=================================================================
    # ��  ��: ����������ư��λ�����륳���ɤ�
    #         IMCodeElement���饹�ˤޤȤ���֤�
    #=================================================================
    def gc_lastpost_all_task_ter_fmp()
      # ¾��������¸�ߤ����硤���٤�ter_tsk()������
      cElement = IMCodeElement.new()

      hProcUnitInfo = get_proc_unit_info()
      nMainPrcid = @sMainPrcid

      # �ᥤ�󥿥������ץꥨ��ץȤ���뤳�Ȥ��ɤ������
      # �¹Բ�ǽ���֤Υ����������Ԥ����֤ˤ��Ƥ���
      @aTask.each{|nPrcid, sObjectID, cObjectInfo|
        if (cObjectInfo.hState[TSR_PRM_STATE] == KER_TTS_RDY)
          cElement.set_syscall(hProcUnitInfo, "#{API_SUS_TSK}(#{sObjectID})")
        end
      }
      # �¹Ծ��֤Υ����������Ԥ����֤ˤ��Ƥ���
      @aTask.each{|nPrcid, sObjectID, cObjectInfo|
        if (cObjectInfo.hState[TSR_PRM_STATE] == KER_TTS_RUN)
          cElement.set_syscall(hProcUnitInfo, "#{API_SUS_TSK}(#{sObjectID})")
        end
      }

      # �����Ԥ��ˤ����ޤ��Ԥ�
      # �¹Ծ��֤���ͥ���٤��⤤�����θ���ơ��¹Բ�ǽ���֤Υ��������Ԥ�����
      cElement.set_checkpoint(get_proc_unit_info())
      @aTask.each{|nPrcid, sObjectID, cObjectInfo|
        if (cObjectInfo.hState[TSR_PRM_STATE] == KER_TTS_RDY || KER_TTS_RUN || KER_TTS_RUS)
          cElement.set_wait_finish_sync(get_proc_unit_info(cObjectInfo))
        end
      }

      @aTask.each{|nPrcid, sObjectID, cObjectInfo|
        # �ᥤ�󥿥������оݥ������Υץ��å����ۤʤ���ϥᥤ�󥿥������ư
        if (nMainPrcid != nPrcid)
          cElement.set_syscall(hProcUnitInfo, "#{API_MIG_TSK}(#{TTG_TSK_SELF}, #{nPrcid})")
          nMainPrcid = nPrcid
        end

        if (cObjectInfo.hState[TSR_PRM_STATE] != KER_TTS_DMT)
          cElement.set_syscall(hProcUnitInfo, "#{API_TER_TSK}(#{sObjectID})")
        end
      }
      # �Ǹ��ɬ���ᥤ��ץ��å������
      if (nMainPrcid != @sMainPrcid)
        cElement.set_syscall(hProcUnitInfo, "#{API_MIG_TSK}(#{TTG_TSK_SELF}, #{@sMainPrcid})")
      end
      cElement.set_checkpoint(hProcUnitInfo)

      return cElement  # [IMCodeElement]����������ư��λ�����륳����
    end

    #=================================================================
    # ��  ��: �Ǹ��ref����λ����ޤ�¾�ץ��å��θ������ߤ�Ƥ���
    #         Ʊ��
    #=================================================================
    def gc_last_running_sync()
      cElement = IMCodeElement.new()

      # �¹Ծ��֤ν���ñ�̼���
      aActivateRunningProc = get_actvate_running_fmp()
      bFlg = false

      # �¹Ծ��֤ν���ñ��¦��ref����������������������
      # ¾�ץ��å��ν���ñ�̤Υ����å��ݥ���Ȥ��Ԥ�
      aActivateRunningProc.each{|cObjectInfo|
        if (!cObjectInfo.nil?() && (cObjectInfo.hState[TSR_PRM_PRCID] != @sMainPrcid))
          cElement.set_checkpoint(get_proc_unit_info(cObjectInfo))
          cElement.set_wait_check_sync(get_proc_unit_info(@cActivate, @cRunning), cObjectInfo.hState[TSR_PRM_PRCID])
          bFlg = true
        end
      }

      # ¾�ץ��å��ν���ñ�̤��Ԥ���������å��ݥ���Ȥ�����
      cElement.set_checkpoint(get_proc_unit_info(@cActivate, @cRunning))

      aActivateRunningProc.each{|cObjectInfo|
        if (!cObjectInfo.nil?() && (cObjectInfo.hState[TSR_PRM_PRCID] != @sMainPrcid))
          cElement.set_comment(get_proc_unit_info(cObjectInfo), "LastRunningSync")
          cElement.set_wait_check_sync(get_proc_unit_info(cObjectInfo), @sMainPrcid)
          bFlg = true
        end
      }

      if (bFlg == false)
        return nil       # [nil]�ɲä�ɬ�פʤ�
      else
        return cElement  # [IMCodeElement]LastRunningSync������
      end
    end

    #=================================================================
    # ��  ��: �տޤ��ʤ��ǥ����ѥå����ɤ����ᡤ�¹Բ�ǽ���֤Υ�������
    #         �����Ԥ������ܤ����륳���ɤ��֤�
    #=================================================================
    def gc_lastpost_ready_sleep_fmp()
      cElement = IMCodeElement.new()

      @aPrcid.each{|nPrcid|
        if ((@aActivate[nPrcid] != nil) || (!@aCpuState[nPrcid].nil?() &&
            ((@aCpuState[nPrcid].hState[TSR_PRM_LOCCPU] == true) || (@aCpuState[nPrcid].hState[TSR_PRM_DISDSP] == true) ||
            ((@aCpuState[nPrcid].hState[TSR_PRM_CHGIPM] != 0) && (@aCpuState[nPrcid].hState[TSR_PRM_CHGIPM] != KER_TIPM_ENAALL)))))
           @hTask.each{|sObjectID, cObjectInfo|
             if ((cObjectInfo.hState[TSR_PRM_PRCID] == nPrcid) && (cObjectInfo.hState[TSR_PRM_STATE] == KER_TTS_RDY))
               hProcUnitInfo = get_proc_unit_info(cObjectInfo)
               cElement.set_syscall(hProcUnitInfo, "#{API_SLP_TSK}()")
             end
           }
        end
      }

      return cElement  # [IMCodeElement]�����Ԥ����ܥ�����
    end

    #=================================================================
    # ��  ��: ���ԥ��å������Ԥ��Τ�����ٱ�������륳���ɤ��֤�
    #=================================================================
    def gc_delay_wait_spin_fmp(lPrevMainTaskState)
      check_class(Symbol, lPrevMainTaskState)   # �����֤Υᥤ�󥿥����ξ���

      cElement = IMCodeElement.new()

      # �ᥤ�󥿥����ξ��֤Ϥ��ΤޤޤȤ���
      @lMainTaskState = lPrevMainTaskState

      # ���ԥ��å������Ԥ��ν���ñ�̾������
      # (ʣ��¸�ߤ�����Ϥɤ줫���ٱ䤵����Ф褤)
      cWaitProcUnit = nil
      @aActivate.each{|cActivate|
        if (!cActivate.nil?() && (cActivate.hState[TSR_PRM_HDLSTAT] == TSR_STT_A_WAITSPN))
          cWaitProcUnit = cActivate
          break
        end
      }
      @aRunning.each{|cRunning|
        if (!cRunning.nil?() &&
          ((cRunning.hState[TSR_PRM_STATE] == TSR_STT_R_WAITSPN) || (cRunning.hState[TSR_PRM_HDLSTAT] == TSR_STT_A_WAITSPN)))
          cWaitProcUnit = cRunning
          break
        end
      }

      # ���ԥ��å������Ԥ��оݤΥ��ԥ��å���������
      cSpinlockInfo = get_object_info(cWaitProcUnit.hState[TSR_PRM_SPINID])

      # �оݤΥ��ԥ��å���������Ƥ������ñ�̾�������
      hSpinlockProcUnit = get_proc_unit_info(get_object_info(cSpinlockInfo.hState[TSR_PRM_PROCID]))

      # ���ԥ��å���������Ƥ������ñ�̤ˤ������ٱ������¹�
      cElement.set_delay_loop(hSpinlockProcUnit)

      return cElement  # [IMCodeElement]���ԥ��å������Ԥ��Τ�����ٱ�������륳����
    end

    #=================================================================
    # ��  ��: �ػ߾��֤γ���ߤ����ꤹ�륳���ɤ��֤�
    #=================================================================
    def gc_lastpost_interrupt_dis_fmp()
      cElement      = IMCodeElement.new()
      hMainTaskInfo = get_proc_unit_info()

      # dis_int����ɬ�פΤ��������ֹ�����
      aDisIntNoID = []
      @hAllObject.each{|sObjectID, cObjectInfo|
        if ((GRP_INTERRUPT.include?(cObjectInfo.sObjectType) == true) && (cObjectInfo.hState[TSR_PRM_STATE] == KER_TA_ENAINT))
          aDisIntNoID.push([cObjectInfo.hState[TSR_PRM_INTNO], cObjectInfo.hState[TSR_PRM_PRCID]])
        end
      }

      # ��ʣ�������Ƥ��٤�dis_int��¹Ԥ���
      nMainPrcid = @sMainPrcid
      aDisIntNoID.uniq!()
      aDisIntNoID.each{|snIntNoID|
        # �ᥤ�󥿥������о�IntHdr/ISR�Υץ��å����ۤʤ���ϥᥤ�󥿥������ư
        if (nMainPrcid != snIntNoID[1])
          cElement.set_syscall(hMainTaskInfo, "#{API_MIG_TSK}(#{TTG_TSK_SELF}, #{snIntNoID[1]})")
          nMainPrcid = snIntNoID[1]
        end

        cElement.set_syscall(hMainTaskInfo, "#{API_DIS_INT}(#{snIntNoID[0]})")
      }

      # �Ǹ��ɬ���ᥤ��ץ��å������
      if (nMainPrcid != @sMainPrcid)
        cElement.set_syscall(hMainTaskInfo, "#{API_MIG_TSK}(#{TTG_TSK_SELF}, #{@sMainPrcid})")
      end

      cElement.set_checkpoint(hMainTaskInfo)

      return cElement  # [IMCodeElement]�ػ߾��֤γ���ߤ����ꤹ�륳����
    end

    #=================================================================
    # ��  ��: ���ԥ��å������Ԥ����֤ν���ñ�̤�̵ͭ��ǧ���֤�
    #=================================================================
    def exist_wait_spinlock_fmp()
      @aActivate.each{|cActivate|
        if (!cActivate.nil?() && (cActivate.hState[TSR_PRM_HDLSTAT] == TSR_STT_A_WAITSPN))
          return true  # [Bool]���ԥ��å������Ԥ����֤ν���ñ�̤�����
        end
      }

      @aRunning.each{|cRunning|
        if (!cRunning.nil?() &&
          ((cRunning.hState[TSR_PRM_STATE] == TSR_STT_R_WAITSPN) || (cRunning.hState[TSR_PRM_HDLSTAT] == TSR_STT_A_WAITSPN)))
          return true  # [Bool]���ԥ��å������Ԥ����֤ν���ñ�̤�����
        end
      }

      return false  # [Bool]���ԥ��å������Ԥ����֤ν���ñ�̤��ʤ�
    end
  end
end
