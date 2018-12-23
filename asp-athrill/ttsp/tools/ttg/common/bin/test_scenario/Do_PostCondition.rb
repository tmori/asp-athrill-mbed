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
#  $Id: Do_PostCondition.rb 9 2012-09-11 01:47:48Z nces-shigihara $
#
require "common/bin/test_scenario/Condition.rb"
require "ttc/bin/test_scenario/Do_PostCondition.rb"
require "ttj/bin/test_scenario/Do_PostCondition.rb"
require "bin/builder/fmp_builder/test_scenario/Do_PostCondition.rb"

#=====================================================================
# CommonModule
#=====================================================================
module CommonModule
  #===================================================================
  # ���饹̾: Do_PostCondition
  # ��    ��: do��post_condition�ξ����������륯�饹
  #===================================================================
  class Do_PostCondition < Condition
    include CommonModule

    attr_accessor :hDo
    attr_reader :nSeqNum, :nTimeTick

    #=================================================================
    # ��  ��: do��post_condition�ν����
    #=================================================================
    def initialize(sTestID, hScenarioDo, hScenarioPost, nSeqNum, nTimeTick, cPreCondition)
      check_class(String, sTestID)              # �ƥ���ID
      check_class(Hash, hScenarioDo, true)      # do
      check_class(Hash, hScenarioPost, true)    # post_condition
      check_class(Integer, nSeqNum)             # ���������ֹ�
      check_class(Integer, nTimeTick)           # ������ƥ��å�
      check_class(PreCondition, cPreCondition)  # PreCondition

      @nSeqNum                = nSeqNum
      @nTimeTick              = nTimeTick
      @cCallerObject          = nil        # APIȯ�ԥ��֥�������
      @hDo                    = {}
      @aSpecifiedDoAttributes = []

      super(sTestID)

      # ��¤�����å�
      aErrors = []
      begin
        basic_post_check(hScenarioPost)
      rescue TTCMultiError
        aErrors.concat($!.aErrors)
      end
      check_error(aErrors)

      # �䴰
      if (hScenarioDo.nil?())
        hScenarioDo = {}
      end
      if (hScenarioPost.nil?())
        hScenarioPost = {}
      end
      pre_attribute_check(hScenarioDo)

      # ���顼���ʤ����do��post_condition�ξ����Ǽ
      store_do_info(hScenarioDo, cPreCondition)
      store_condition_info(hScenarioPost, cPreCondition.hObjectType)
    end

    #=================================================================
    # ��  ��: do�ξ�����Ǽ
    #=================================================================
    def store_do_info(hScenarioDo, cPreCondition)
      check_class(Hash, hScenarioDo)            # do
      check_class(PreCondition, cPreCondition)  # PreCondition

      # ��Ǽ
      @aSpecifiedDoAttributes = hScenarioDo.keys()
      hScenarioDo.each{|atr, val|
        case atr
        when TSR_PRM_ID
          @hDo[atr] = val
          @cCallerObject = cPreCondition.hAllObject[val]

        else
          @hDo[atr] = val
        end
      }
    end


    #=================================================================
    # ��  ��: ����ñ�̾����ޤȤ�ƥ�����ȤȤ����֤�
    #=================================================================
    def get_proc_units(cElement)
      @hAllObject.each{|sObjectID, cObjectInfo|
        if (GRP_PROCESS_UNIT.include?(cObjectInfo.sObjectType))
          cElement.set_proc_unit(sObjectID, cObjectInfo.hState[TSR_PRM_BOOTCNT])
        end
      }
    end

    #=================================================================
    # ��  ��: Do�ν�����IMCodeElement���饹�ˤޤȤ���֤�
    #=================================================================
    def gc_do(cPrevObjectInfo)
      check_class(ProcessUnit, cPrevObjectInfo) # ���Υ���ǥ������

      cElement = IMCodeElement.new()

      hProcUnitInfo = get_proc_unit_info(cPrevObjectInfo)

      # id�˵��ܤ���ID�Ȱ��פ��Ƥ��뤳�Ȥ��ǧ����
      if (hProcUnitInfo[:id] != @hDo[TSR_PRM_ID])
        abort(ERR_MSG % [__FILE__, __LINE__])
      end

      # �����Ƚ���
      cElement.set_comment(hProcUnitInfo, "#{TSR_UNS_DO}#{@nSeqNum}_#{@nTimeTick}")
      # GCOV�����γ��Ϥ⤷���ϺƳ�
      gc_gcov_resume(cElement, hProcUnitInfo)

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
      if (bIsReturn == true)
        # ����ͤ������硤������¹Ծ��֤ˤʤ뤿��API��ȯ�Ԥ�������ñ�̤ǹԤ�
        gc_gcov_pause(cElement, hProcUnitInfo)
      else
        # ����ͤ�̵����硤do�θ�Ǽ¹���ν���ñ�̤���Ԥ�
        gc_gcov_pause(cElement, get_proc_unit_info(@cActivate, @cRunning))
      end

      return cElement # [IMCodeElement]�������
    end

    #=================================================================
    # ��  ��: gcov�������Ϥν�����IMCodeElement���饹���ɲä���
    #         �֤�
    #=================================================================
    def gc_gcov_resume(cElement, hProcUnitInfo)
      check_class(IMCodeElement, cElement) # IMCodeElement���饹�Υ��󥹥���
      check_class(Hash, hProcUnitInfo)     # ������¹Ԥ������ñ�̾���

      if (@cConf.enable_gcov?() && (@hDo[TSR_PRM_GCOV] == true) && (@bGcovAll == false))
        cElement.set_code(hProcUnitInfo, FNC_GCOV_TTG_C_RESUME)
      end
    end

    #=================================================================
    # ��  ��: gcov�������Ǥν�����IMCodeElement���饹���ɲä����֤�
    #=================================================================
    def gc_gcov_pause(cElement, hProcUnitInfo)
      check_class(IMCodeElement, cElement) # IMCodeElement���饹�Υ��󥹥���
      check_class(Hash, hProcUnitInfo)     # ������¹Ԥ������ñ�̾���

      if (@cConf.enable_gcov?() && (@hDo[TSR_PRM_GCOV] == true) && (@bGcovAll == false))
        cElement.set_code(hProcUnitInfo, FNC_GCOV_TTG_C_PAUSE)
      end
    end

    #=================================================================
    # ��  ��: CPU��å����֤β���ν�����
    #         IMCodeElement���饹�ˤޤȤ���֤�
    #=================================================================
    def gc_lastpost_cpu_unl()
      cElement = IMCodeElement.new()
      hProcUnitInfo = get_proc_unit_info(@cActivate, @cRunning)

      if (!@cActivate.nil?())
        cElement.set_syscall(hProcUnitInfo, "#{API_IUNL_CPU}()")
      else
        cElement.set_syscall(hProcUnitInfo, "#{API_UNL_CPU}()")
      end

      return cElement # [IMCodeElement]�������
    end

    #=================================================================
    # ��  ��: �Ǹ�θ���֤ǥᥤ�󥿥����򵯤��������ɤ��֤�
    #=================================================================
    def gc_lastpost_maintask_wup(lPrevMainTaskState)
      cElement = IMCodeElement.new()

      # �����֤ǥᥤ�󥿥������¹Ծ��֤ξ��
      if (lPrevMainTaskState == :running)
        # �ᥤ�󥿥������¹���Ǥ��뤿�ᡤ���⤷�ʤ�

      # �����֤ǥᥤ�󥿥������¹Ծ��֤ξ��
      elsif (lPrevMainTaskState == :ready)
        if (!@cRunning.nil?())
          cElement.set_syscall(get_proc_unit_info(@cRunning), "#{API_CHG_PRI}(#{TTG_MAIN_TASK}, #{TTG_MAIN_PRI})")
          if (check_running_pri(TTG_MAIN_PRI) == true)
            cElement.set_syscall(get_proc_unit_info(@cRunning), "#{API_ROT_RDQ}(#{TTG_MAIN_PRI})")
          end

          # �ᥤ��ץ��å���ͥ���٤�TTG_MAIN_PRI��Ʊ����ready�Υ������������硤rot_rdq��ȯ�Ԥ��ƥǥ����ѥå�������
          @hTask.each{|sObjectID, cObjectInfo|
            if ((cObjectInfo.hState[TSR_PRM_PRCID] == @sMainPrcid) && (cObjectInfo.hState[TSR_PRM_TSKPRI] == TTG_MAIN_PRI) && (cObjectInfo.hState[TSR_PRM_STATE] == KER_TTS_RDY))
              cElement.set_syscall(get_proc_unit_info(cObjectInfo), "#{API_ROT_RDQ}(#{TTG_MAIN_PRI})")
            end
          }
        end

      # �����֤ǥᥤ�󥿥����������Ԥ����֤ξ��
      elsif (lPrevMainTaskState == :sleep)
        if (!@cRunning.nil?())
          cElement.set_syscall(get_proc_unit_info(@cRunning), "#{API_WUP_TSK}(#{TTG_MAIN_TASK})")
          cElement.set_syscall(get_proc_unit_info(@cRunning), "#{API_CHG_PRI}(#{TTG_MAIN_TASK}, #{TTG_MAIN_PRI})")
          if (check_running_pri(TTG_MAIN_PRI) == true)
            cElement.set_syscall(get_proc_unit_info(@cRunning), "#{API_ROT_RDQ}(#{TTG_MAIN_PRI})")
          end

          # �ᥤ��ץ��å���ͥ���٤�TTG_MAIN_PRI��Ʊ����ready�Υ������������硤rot_rdq��ȯ�Ԥ��ƥǥ����ѥå�������
          @hTask.each{|sObjectID, cObjectInfo|
            if ((cObjectInfo.hState[TSR_PRM_PRCID] == @sMainPrcid) && (cObjectInfo.hState[TSR_PRM_TSKPRI] == TTG_MAIN_PRI) && (cObjectInfo.hState[TSR_PRM_STATE] == KER_TTS_RDY))
              cElement.set_syscall(get_proc_unit_info(cObjectInfo), "#{API_ROT_RDQ}(#{TTG_MAIN_PRI})")
            end
          }

        elsif (!@cActivate.nil?())
          cElement.set_syscall(get_proc_unit_info(@cActivate), "#{API_IWUP_TSK}(#{TTG_MAIN_TASK})")

        # �ᥤ�󥿥����򵯾��Ǥ������ñ�̤����ʤ�
        else
          abort(ERR_MSG % [__FILE__, __LINE__])
        end

      else
        abort(ERR_MSG % [__FILE__, __LINE__])
      end

      return cElement # [IMCodeElement]�������
    end

    #=================================================================
    # ��  ��: �ǥ����ѥå��ػ߾��֤������������
    #         IMCodeElement���饹�ˤޤȤ���֤�
    #=================================================================
    def gc_lastpost_ena_dsp()
      cElement      = IMCodeElement.new()
      hProcUnitInfo = get_proc_unit_info(@cRunning)

      cElement.set_syscall(hProcUnitInfo, "#{API_ENA_DSP}()")

      return cElement # [IMCodeElement]�������
    end

    #=================================================================
    # ��  ��: �����ͥ���٥ޥ��������������������
    #         IMCodeElement���饹�ˤޤȤ���֤�
    #=================================================================
    def gc_lastpost_set_ini_ipm()
      cElement      = IMCodeElement.new()
      hProcUnitInfo = get_proc_unit_info(@cRunning)

      cElement.set_syscall(hProcUnitInfo, "#{API_CHG_IPM}(#{KER_TIPM_ENAALL})")

      return cElement # [IMCodeElement]�������
    end

    #=================================================================
    # ��  ��: ư����֤Υ����।�٥�ȥϥ�ɥ����߽����Υ����ɤ�
    #         IMCodeElement���饹�ˤޤȤ���֤�
    #         (��Χ�ᥤ�󥿥������¹Ԥ���)
    #=================================================================
    def gc_lastpost_time_event_stp()
      cElement      = IMCodeElement.new()
      hProcUnitInfo = get_proc_unit_info()

      @hAllObject.each{|sObjectID, cObjectInfo|
        if (cObjectInfo.sObjectType == TSR_OBJ_ALARM)
          cElement.set_syscall(hProcUnitInfo, "#{API_STP_ALM}(#{sObjectID})")
        elsif (cObjectInfo.sObjectType == TSR_OBJ_CYCLE)
          cElement.set_syscall(hProcUnitInfo, "#{API_STP_CYC}(#{sObjectID})")
        end
      }

      cElement.set_checkpoint(hProcUnitInfo)

      return cElement # [IMCodeElement]�������
    end

    #=================================================================
    # ��  ��: �ػ߾��֤γ���ߤ����ꤹ�륳���ɤ��֤�
    #=================================================================
    def gc_lastpost_interrupt_dis()
      cElement      = IMCodeElement.new()
      hMainTaskInfo = get_proc_unit_info()

      # dis_int����ɬ�פΤ��������ֹ�����
      aDisIntNo = []
      @hAllObject.each{|sObjectID, cObjectInfo|
        if ((GRP_INTERRUPT.include?(cObjectInfo.sObjectType) == true) && (cObjectInfo.hState[TSR_PRM_STATE] == KER_TA_ENAINT))
          aDisIntNo.push(cObjectInfo.hState[TSR_PRM_INTNO])
        end
      }

      # ��ʣ�������Ƥ��٤�dis_int��¹Ԥ���
      aDisIntNo.uniq!()
      aDisIntNo.each{|snIntNo|
        cElement.set_syscall(hMainTaskInfo, "#{API_DIS_INT}(#{snIntNo})")
      }

      cElement.set_checkpoint(hMainTaskInfo)

      return cElement # [IMCodeElement]�������
    end

    #=================================================================
    # ��  ��: ���ξ��֤�����������˹Ԥ��٤��Υᥤ������������
    #         IMCodeElement���饹���饹�ˤޤȤ���֤�
    #=================================================================
    def gc_post_maintask_set(cNextActivate, cNextRunning, bNextCpuLock, bNextRunSus, lPrevMainTaskState, bGainTime)
      check_class(ProcessUnit, cNextActivate, true) # ���Υ���ǥ������ǵ�ư���Ƥ����󥿥���
      check_class(ProcessUnit, cNextRunning, true)  # ���Υ���ǥ������Ǽ¹���Υ�����
      check_class(Bool, bNextCpuLock)               # ���Υ���ǥ�������CPU��å����ɤ���
      check_class(Bool, bNextRunSus)                # ���Υ���ǥ������ǲ��Ͼ��֤��ɤ���
      check_class(Symbol, lPrevMainTaskState)       # ���Υ���ǥ������Υᥤ�󥿥����ξ���
      check_class(Bool, bGainTime)                  # ���֤�ʤ��ɬ�פ����뤫�ɤ���

      cElement      = IMCodeElement.new()
      hMainTaskInfo = get_proc_unit_info()

      # ���ߤ�CPU���֤����
      bNowCpuLock = check_cpu_loc()

      # ���ߤȸ���֤β��Ͼ��֤����
      bNowRunSus = check_run_sus()

      # CPU��å����֤ξ��(����ȯ�ԤǤ��ʤ�)
      if (bNowCpuLock == true)
        @lMainTaskState = lPrevMainTaskState
        return nil
      end

      # �����֤ǥᥤ�󥿥������¹Ծ��֤ξ��
      if (lPrevMainTaskState == :running)
        # ���ξ��򤹤٤���������硤���Υ���ǥ�������
        # �ᥤ�󥿥����򵯾��Ǥ��뤿�ᡤslp_tsk����
        # 1)���Υ���ǥ������˼¹Ծ��֤Υ�������¸�ߤ���
        # 2)���Υ���ǥ������μ¹Ծ��֤Υ����������Ͼ��֤Ǥʤ�
        #   (������ǲ��Ͼ��֤������������Ƕ����Ԥ��Ȥʤꡤ�ᥤ�󥿥����򵯾��Ǥ��ʤ�)
        # 3)���Υ���ǥ������CPU��å��Ǥʤ�
        #   (ʣ����do/post��³�����������chg_pri/wup_tsk��ȯ�ԤǤ��ʤ���ǽ��������)
        if ((!cNextActivate.nil?() || !cNextRunning.nil?()) && (bNextRunSus == false) && (bNextCpuLock == false))
          cElement.set_syscall(hMainTaskInfo, "#{API_SLP_TSK}()")
          @lMainTaskState = :sleep

        # �嵭�ʳ��ϲ��⤷�ʤ�
        else
          @lMainTaskState = lPrevMainTaskState
        end

      # �����֤ǥᥤ�󥿥����������Ԥ����֤ξ��
      elsif (lPrevMainTaskState == :sleep)
        # ���߼¹Ծ��֤Υ�������¸�ߤ��ʤ������Ļ��֤�ʤ��ɬ�פ��������
        # �ᥤ�󥿥������ö��ư���ƻ��֤�ʤᤵ����
        if (@cRunning.nil?() && (bGainTime == true))
          hProcUnitInfo = get_proc_unit_info(@cActivate)
          cElement.set_syscall(hProcUnitInfo, "#{API_IWUP_TSK}(#{TTG_MAIN_TASK})")

          @lMainTaskState = :running

        # ���Τ����줫�ξ�����������硤���Υ���ǥ�������
        # �¹Ծ��֤ν���ñ�̤����ʤ��ʤ뤿�ᡤ�ᥤ�󥿥����򵯾�����
        # 1)���Υ���ǥ������˼¹Ծ��֤ν���ñ�̤�¸�ߤ��ʤ�
        # 2)���Υ���ǥ������CPU��å�����
        # (do/post��³�����������chg_pri/wup_tsk��ȯ�ԤǤ��ʤ���ǽ��������)
        # 3)���Υ���ǥ������μ¹Ծ��֤ν���ñ�̤����Ͼ���
        # (������ǲ��Ͼ��֤������������Ƕ����Ԥ��Ȥʤꡤ�ᥤ�󥿥����򵯾��Ǥ��ʤ�)
        elsif ((cNextActivate.nil?() && cNextRunning.nil?()) || (bNextCpuLock == true) || (bNextRunSus == true))
          hProcUnitInfo = get_proc_unit_info(@cActivate, @cRunning)
          if (@cActivate.nil?())
            cElement.set_syscall(hProcUnitInfo, "#{API_CHG_PRI}(#{TTG_MAIN_TASK}, #{TTG_WAIT_PRI})")
            cElement.set_syscall(hProcUnitInfo, "#{API_WUP_TSK}(#{TTG_MAIN_TASK})")

          else
            cElement.set_syscall(hProcUnitInfo, "#{API_IWUP_TSK}(#{TTG_MAIN_TASK})")

            # �¹Ծ��֤Υ������������硤�ᥤ�󥿥������¹Ծ��֤Ȥʤ�ʤ��褦chg_pri���Ƥ���
            if (!@cRunning.nil?())
              cElement.set_syscall(hMainTaskInfo, "#{API_CHG_PRI}(#{TTG_MAIN_TASK}, #{TTG_WAIT_PRI})")
              if (check_running_pri(TTG_WAIT_PRI) == true)
                cElement.set_syscall(hMainTaskInfo, "#{API_ROT_RDQ}(#{TTG_WAIT_PRI})")
              end
            end
          end

          @lMainTaskState = :ready
        # �嵭�ʳ��ϲ��⤷�ʤ�
        else
          @lMainTaskState = lPrevMainTaskState
        end

      elsif (lPrevMainTaskState == :ready)
        # ���ξ��򤹤٤���������硤���Υ���ǥ�������
        # �ᥤ�󥿥����򵯾��Ǥ��뤿�ᡤͥ���٤��ᤷ��slp_tsk����
        # 1)���Υ���ǥ������˼¹Ծ��֤ν���ñ�̤�¸�ߤ���
        # 2)���Υ���ǥ������μ¹Ծ��֤Υ����������Ͼ��֤Ǥʤ�
        #   (������ǲ��Ͼ��֤������������Ƕ����Ԥ��Ȥʤꡤ�ᥤ�󥿥����򵯾��Ǥ��ʤ�)
        # 3)���Υ���ǥ������CPU��å��Ǥʤ�
        #   (ʣ����do/post��³�����������chg_pri/wup_tsk��ȯ�ԤǤ��ʤ���ǽ��������)
        if ((!cNextActivate.nil?() || !cNextRunning.nil?()) && (bNextRunSus == false) && (bNextCpuLock == false))
          # �ᥤ�󥿥���������TTG_MAIN_PRI�ξ���chg_pri��ȯ�Ԥ��ʤ�
          cElement.set_chg_pri_main_task(hMainTaskInfo)

          cElement.set_syscall(hMainTaskInfo, "#{API_SLP_TSK}()")
          @lMainTaskState = :sleep

        # ���Υ���ǥ������˼¹Ծ��֤Υ�������¸�ߤ��ʤ����
        # �ᥤ�󥿥�����¹Ծ��֤Ȥ���
        elsif (cNextRunning.nil?())
          hProcUnitInfo = get_proc_unit_info(@cRunning)
          cElement.set_syscall(get_proc_unit_info(), "#{API_CHG_PRI}(#{TTG_TSK_SELF}, #{TTG_MAIN_PRI})")

          @lMainTaskState = :running
        # �嵭�ʳ��ϲ��⤷�ʤ�
        else
          @lMainTaskState = lPrevMainTaskState
        end

      else
        abort(ERR_MSG % [__FILE__, __LINE__])
      end

      return cElement # [IMCodeElement]�������
    end

    #=================================================================
    # ��  ��: ��ư�������׵ᥭ�塼���󥰤�����򤹤������
    #         IMCodeElement���饹�ˤޤȤ���֤�
    #         (��Χ�ᥤ�󥿥������¹Ԥ���)
    #=================================================================
    def gc_lastpost_task_can_queueing()
      cElement = IMCodeElement.new()

      hProcUnitInfo = get_proc_unit_info()

      @hTask.each{|sObjectID, cObjectInfo|
        if (!cObjectInfo.hState[TSR_PRM_ACTCNT].nil?() && cObjectInfo.hState[TSR_PRM_ACTCNT] > 0)
          cElement.set_local_var(hProcUnitInfo[:id], TSR_PRM_ERUINT, "ER_UINT")
          cObjectInfo.hState[TSR_PRM_ACTCNT].times{
            cElement.set_syscall(hProcUnitInfo, "#{API_CAN_ACT}(#{sObjectID})", nil, TYP_ER_UINT)
            cElement.set_assert(hProcUnitInfo, TSR_PRM_ERUINT, cObjectInfo.hState[TSR_PRM_ACTCNT])
          }
        end

      }

      cElement.set_checkpoint(hProcUnitInfo)

      return cElement # [IMCodeElement]�������
    end

    #=================================================================
    # ��  ��: ready�Υ�����������slp_tsk���������
    #         IMCodeElement���饹�ˤޤȤ���֤�
    #=================================================================
    def gc_lastpost_ready_sleep()
      cElement = IMCodeElement.new()

      @hTask.each{|sObjectID, cObjectInfo|
        if (cObjectInfo.hState[TSR_PRM_STATE] == KER_TTS_RDY)
          hProcUnitInfo = get_proc_unit_info(cObjectInfo)
          cElement.set_syscall(hProcUnitInfo, "#{API_SLP_TSK}()")
        end
      }

      return cElement # [IMCodeElement]�������
    end

    #=================================================================
    # ��  ��: ����������ư��λ�����륳���ɤ�
    #         IMCodeElement���饹�ˤޤȤ���֤�
    #=================================================================
    def gc_lastpost_all_task_ter()
      # ¾��������¸�ߤ����硤���٤�ter_tsk()������
      cElement = IMCodeElement.new()

      hProcUnitInfo = get_proc_unit_info()

      @hTask.each{|sObjectID, cObjectInfo|
        if (cObjectInfo.hState[TSR_PRM_STATE] != KER_TTS_DMT)
          cElement.set_syscall(hProcUnitInfo, "#{API_TER_TSK}(#{sObjectID})")
        end
      }

      cElement.set_checkpoint(hProcUnitInfo)

      return cElement # [IMCodeElement]�������
    end

    #=================================================================
    # ��  ��: ��������å��ݥ���Ȥ���Ϥ��������
    #         IMCodeElement���饹�ˤޤȤ���֤�
    #=================================================================
    def gc_checkpoint_zero()
      cElement = IMCodeElement.new()

      @hTask.each{ |sObjectID, cObjectInfo|
        hProcUnitInfo = get_proc_unit_info(cObjectInfo)
        cElement.set_checkpoint_zero(hProcUnitInfo)
      }

      return cElement # [IMCodeElement]�������
    end

    #=================================================================
    # ��  ��: ���Υ���ǥ������ǵ�ư����ACTIVATE���󥿥�����¸�ߤ���
    #         ��硤��ư���Ԥĥ����ɤ��֤�
    #=================================================================
    def gc_wait_non_task_activate(cPrevActivate, bGainTime)
      check_class(ProcessUnit, cPrevActivate, true)  # ���Υ���ǥ�������ACTIVATE�Ǥ����󥿥���
      check_class(Bool, bGainTime)                   # ���֤�ʤ�뤫

      cElement = IMCodeElement.new()

      # �󥿥�����¸�ߤ�����Τ�
      if (!@cActivate.nil?())
        hActivateInfo = get_proc_unit_info(@cActivate)
        hRunningInfo = get_proc_unit_info(@cRunning)
        # ���֤�ߤ�ʤ��ƥ��ȥ������ξ�硤��ư���Ԥ��ʤ�
        if (GRP_TIME_EVENT_HDL.include?(@cActivate.sObjectType) && (bGainTime == true))
        # ���Υ���ǥ��������󥿥��������ʤ���硤���������鵯ư���Ԥ�
        elsif (cPrevActivate.nil?())
          cElement.set_checkpoint(hActivateInfo)
          cElement.wait_checkpoint(hRunningInfo)
        # �ۤʤ��󥿥�����ACTIVATE�ˤʤä����ϡ������󥿥������鵯ư���Ԥ�
        elsif (cPrevActivate.sObjectID != @cActivate.sObjectID)
          cElement.set_checkpoint(hActivateInfo)
          cElement.wait_checkpoint(get_proc_unit_info(cPrevActivate))
        # Ʊ���󥿥�����bootcnt���Ѥ�äƤ�����ϡ����٥���������뤿�᥿���������Ԥ�
        elsif (cPrevActivate.hState[TSR_PRM_BOOTCNT] != @cActivate.hState[TSR_PRM_BOOTCNT])
          cElement.set_checkpoint(hActivateInfo)
          cElement.wait_checkpoint(hRunningInfo)
        end
      end

      return cElement # [IMCodeElement]�������
    end
  end
end
