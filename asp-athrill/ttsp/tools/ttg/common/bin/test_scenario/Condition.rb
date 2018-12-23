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
require "common/bin/CommonModule.rb"
require "common/bin/Config.rb"
require "common/bin/process_unit/Task.rb"
require "common/bin/process_unit/Alarm.rb"
require "common/bin/process_unit/Cyclic.rb"
require "common/bin/process_unit/TaskExcept.rb"
require "common/bin/process_unit/IntHdr.rb"
require "common/bin/process_unit/ISR.rb"
require "common/bin/process_unit/Execption.rb"
require "common/bin/process_unit/IniRtn.rb"
require "common/bin/process_unit/TerRtn.rb"
require "common/bin/sc_object/Semaphore.rb"
require "common/bin/sc_object/Eventflag.rb"
require "common/bin/sc_object/Dataqueue.rb"
require "common/bin/sc_object/PriDataQ.rb"
require "common/bin/sc_object/Mailbox.rb"
require "common/bin/sc_object/MemPFix.rb"
require "common/bin/sc_object/Spinlock.rb"
require "common/bin/sys_state/CPUState.rb"
require "common/bin/IMCodeElement.rb"
require "ttc/bin/test_scenario/Condition.rb"
require "ttj/bin/test_scenario/Condition.rb"
require "bin/builder/fmp_builder/test_scenario/Condition.rb"

#=====================================================================
# CommonModule
#=====================================================================
module CommonModule
  #===================================================================
  # ���饹̾: Condition
  # ��    ��: pre_condition, post_condition�ξ����������륯�饹
  #===================================================================
  class Condition
    include CommonModule

    attr_reader :hAllObject, :sTestMain, :hTask, :cActivate, :aActivate, :cRunning, :aRunning
    attr_reader :bIsIniRtn, :bIsTerRtn, :bIsIntHdr, :bIsISR, :bIsException, :lMainTaskState

    #=================================================================
    # ��  ��: ���󥹥ȥ饯��
    #=================================================================
    def initialize(sTestID)
      check_class(String, sTestID)        # �ƥ���ID

      @hAllObject = {}                 # �������줿�����֥������Ȥξ�����ݻ����뤿��Υϥå���
      @cConf      = Config.new()       # ����ե����μ���
      @sTestID    = sTestID
      @sTestMain  = sTestID + "_main"  # �ᥤ��ؿ�̾������

      @hMainTaskInfo = {               # �ᥤ�󥿥�������
        :id      => @sTestMain,
        :prcid   => @cConf.get_main_prcid(),
        :bootcnt => TTG_MAIN_BOOTCNT
      }

      @bIsIniRtn    = false    # ������롼�����̵ͭ
      @bIsTerRtn    = false    # ��λ�롼�����̵ͭ
      @bIsIntHdr    = false    # ����ߥϥ�ɥ��̵ͭ
      @bIsISR       = false    # ����ߥ����ӥ��롼�����̵ͭ
      @bIsException = false    # CPU�㳰�ϥ�ɥ��̵ͭ

      @bGcovAll = false  # GCOV�������ե饰

      # FMP��
      @sMainPrcid  = @cConf.get_main_prcid() # �ᥤ��ץ��å�ID
      nPrcNum      = @cConf.get_prc_num()    # �ץ��å���
      @aPrcid      = (1..nPrcNum).to_a()     # �ץ��å��롼�פΤ��������
      @bPassed     = false
      @aSpinProcID = []                      # ���ԥ��å���������Ƥ������ñ��ID

    end

    #=================================================================
    # ��  ��: �ƥ��֥������Ȥ���������
    #=================================================================
    def store_condition_info(hCondition, hObjectType)
      check_class(Hash, hCondition)  # ����ǥ���������
      check_class(Hash, hObjectType) # ���֥������ȥ�����

      # ���֥�����������
      aErrors = []
      aPath = get_condition_path()
      bIsPre  = (self.class() == PreCondition)
      hCondition.each{|sObjectID, hObjectInfo|
        ### T5_001: post_condition��pre_condition���������Ƥ��ʤ����֥�������ID��¸�ߤ���
        unless (hObjectType.has_key?(sObjectID))
          sErr = sprintf("T5_001: " + ERR_OBJECT_NOT_DEFINED_IN_PRE, sObjectID)
          aErrors.push(YamlError.new(sErr, aPath))
        else
          begin
            sObjectType = hObjectType[sObjectID]
            case sObjectType
            when TSR_OBJ_TASK
              cNewObject = Task.new(sObjectID, hObjectInfo, aPath, bIsPre)
            when TSR_OBJ_ALARM
              cNewObject = Alarm.new(sObjectID, hObjectInfo, aPath, bIsPre)
            when TSR_OBJ_CYCLE
              cNewObject = Cyclic.new(sObjectID, hObjectInfo, aPath, bIsPre)
            when TSR_OBJ_TASK_EXC
              cNewObject = TaskExcept.new(sObjectID, hObjectInfo, aPath, bIsPre)
            when TSR_OBJ_SEMAPHORE
              cNewObject = Semaphore.new(sObjectID, hObjectInfo, aPath, bIsPre)
            when TSR_OBJ_EVENTFLAG
              cNewObject = Eventflag.new(sObjectID, hObjectInfo, aPath, bIsPre)
            when TSR_OBJ_DATAQUEUE
              cNewObject = Dataqueue.new(sObjectID, hObjectInfo, aPath, bIsPre)
            when TSR_OBJ_P_DATAQUEUE
              cNewObject = PriDataQ.new(sObjectID, hObjectInfo, aPath, bIsPre)
            when TSR_OBJ_MAILBOX
              cNewObject = Mailbox.new(sObjectID, hObjectInfo, aPath, bIsPre)
            when TSR_OBJ_MEMORYPOOL
              cNewObject = MemPFix.new(sObjectID, hObjectInfo, aPath, bIsPre)
            when TSR_OBJ_CPU_STATE
              cNewObject = CPUState.new(sObjectID, hObjectInfo, aPath, bIsPre)
            when TSR_OBJ_SPINLOCK
              cNewObject = Spinlock.new(sObjectID, hObjectInfo, aPath, bIsPre)
            when TSR_OBJ_INTHDR
              cNewObject = IntHdr.new(sObjectID, hObjectInfo, aPath, bIsPre)
              @bIsIntHdr = true
            when TSR_OBJ_ISR
              cNewObject = ISR.new(sObjectID, hObjectInfo, aPath, bIsPre)
              @bIsISR = true
            when TSR_OBJ_EXCEPTION
              cNewObject = CPUException.new(sObjectID, hObjectInfo, aPath, bIsPre)
              @bIsException = true
            when TSR_OBJ_INIRTN
              cNewObject = IniRtn.new(sObjectID, hObjectInfo, aPath, bIsPre)
              @bIsIniRtn = true
            when TSR_OBJ_TERRTN
              cNewObject = TerRtn.new(sObjectID, hObjectInfo, aPath, bIsPre)
              @bIsTerRtn = true
            else
              abort(ERR_MSG % [__FILE__, __LINE__])
            end

            # �������줿���֥������Ȥ�@hAllObject���ݻ�
            @hAllObject[sObjectID] = cNewObject
          # ���֥���������������ȯ���������顼��ޤȤ��
          rescue TTCMultiError
            aErrors.concat($!.aErrors)
          end
        end
      }

      check_error(aErrors)
    end

    #=================================================================
    # ������: ���󥹥����ѿ������
    #=================================================================
    def init_instance_variables()
      @hTask       = get_objects_by_type(TSR_OBJ_TASK)   # �������Υꥹ�Ⱥ���
      @hWaitObject = get_objects_by_type(GRP_SC_OBJECT)  # �Ԥ����֥������ȤΥꥹ�Ⱥ���

      # �������ȥ������㳰�δ�Ϣ�դ�
      @hAllObject.each{|key, val|
        if (val.sObjectType == TSR_OBJ_TASK_EXC)
          sObjectID = val.hState[TSR_PRM_TASK]
          unless (@hAllObject[sObjectID].nil?())
            @hAllObject[sObjectID].set_tex(val)
            # ��Ϣ�������γ�ĥ����򥿥����㳰���饹�ˤ���Ͽ����(assert������)
            val.hState[TSR_PRM_EXINF] = @hAllObject[sObjectID].hState[TSR_PRM_EXINF]
            # ��Ϣ��������prcid�򥿥����㳰���饹�ˤ���Ͽ����(FMP)
            val.hState[TSR_PRM_PRCID] = @hAllObject[sObjectID].hState[TSR_PRM_PRCID]
          end
        end
      }

      # ���������Ԥ��װ�°������
      @hTask.each{|sObjectID, cObjectInfo|
        # �Ԥ��оݤ����֥������Ȥξ��Τ�����
        if (cObjectInfo.has_wait_object?())
          cObjectInfo.set_task_wait(@hAllObject[cObjectInfo.hState[TSR_PRM_WOBJID]])
        end
      }

      # asp
      if (@cConf.is_asp?())
        @cCpuState = get_cpu_state()
        @cActivate = get_activate()
        @cRunning  = get_running()
      # fmp
      elsif (@cConf.is_fmp?())
        @aTask = []
        @hTask.each{ |key, val|
          @aTask.push([val.hState[TSR_PRM_PRCID], key, val])
        }

        @aCpuState = get_cpu_state_fmp()
        @aActivate = get_activate_fmp()
        @aRunning  = get_running_fmp()
        # c�Ϥϥᥤ��ץ��å�ID�Τ�Τ�ؤ������褦������
        @cCpuState = @aCpuState[@sMainPrcid]
        @cRunning  = @aRunning[@sMainPrcid]
        @cActivate = @aActivate[@sMainPrcid]
      end
    end

    #=================================================================
    # ������: ���ꤷ�������פ˰��פ��륪�֥������Ȥ����
    #=================================================================
    def get_objects_by_type(saType)
      check_class([String, Array], saType)  # ���֥������ȥ�����

      # ʸ����ξ������ˤ���
      if (saType.is_a?(String))
        saType = saType.each_line().to_a()
      end
      # �����֥������Ⱦ��󤫤鳺�����륿���פΥ��֥������Ȥ�ȴ���Ф�
      hResult = @hAllObject.reject{|sObjectID, cObjectInfo|
        !(saType.include?(cObjectInfo.sObjectType))
      }

      return hResult # [Hash]���֥������ȤΥϥå���
    end

    #=================================================================
    # ��  ��: ���֥�������ID�ǳ����Υ��֥������Ȥξ����õ�����֤�
    #=================================================================
    def get_object_info(sObjectID)
      check_class(String, sObjectID)

      return @hAllObject[sObjectID] # [Object]���֥������ȥ��饹
    end

    #=================================================================
    # ��  ��: �¹�����󥿥����Τ������false��
    #         �¹�����󥿥����Τʤ�����true���֤�
    #=================================================================
    def check_activate_context()
      if (@cActivate.nil?())
        return true # [Bool]�󥿥�����������
      else
        return false # [Bool]�󥿥������ʤ����
      end
    end

    #=================================================================
    # ��  ��: �¹���Υ��������֤�
    #         (ACTIVATE�ʥ������㳰����Ϣ�դ��Ƥ�����ϥ������㳰���֤�)
    #=================================================================
    def get_running()
      @hTask.each{|sObjectID, cObjectInfo|
        if ((cObjectInfo.sObjectType == TSR_OBJ_TASK) && GRP_ACTIVATE.include?(cObjectInfo.hState[TSR_PRM_STATE]))
          if (!cObjectInfo.cTex.nil?() && GRP_ACTIVATE.include?(cObjectInfo.cTex.hState[TSR_PRM_HDLSTAT]))
            return cObjectInfo.cTex # [TaskExcept]�¹���Υ������㳰
          else
            return cObjectInfo # [Task]�¹���Υ�����
          end
        end
      }

      return nil
    end

    #=================================================================
    # ��  ��: �¹���ν���ñ�̤��֤�
    #         ���顼��ϥ�ɥ� > �����ϥ�ɥ� > ������
    #=================================================================
    def get_activate()
      @hAllObject.each{|sObjectID, cObjectInfo|
        if (GRP_NON_CONTEXT.include?(cObjectInfo.sObjectType) && GRP_ACTIVATE.include?(cObjectInfo.hState[TSR_PRM_HDLSTAT]))
          return cObjectInfo # [Object] �¹���ν���ñ��
        end
      }

      return nil
    end

    #=================================================================
    # ��  ��: CPU_STATE���֤�
    #=================================================================
    def get_cpu_state()
      @hAllObject.each{|sObjectID, cObjectInfo|
        if (cObjectInfo.sObjectType == TSR_OBJ_CPU_STATE)
          return cObjectInfo
        end
      }

      return nil
    end

    #=================================================================
    # ��  ��: �¹���ν���ñ�̤��֤�
    #=================================================================
    def get_prev_actvate_running()
      if (!@cActivate.nil?())
        return @cActivate # [Object] ��ư��ν���ñ��
      else
        return @cRunning # [Object] �¹���ν���ñ��
      end
    end

    #=================================================================
    # ��  ��: ��������������ɬ�פʥ��֥������Ⱦ����ޤȤ���֤�
    #=================================================================
    def get_proc_unit_info(cFristObject = nil, cSecondObject = nil)
      check_class(ProcessUnit, cFristObject, true)
      check_class(ProcessUnit, cSecondObject, true)

      hProcUnitInfo = {}

      if (!cFristObject.nil?())
        cObjectTemp = cFristObject
      elsif (!cSecondObject.nil?())
        cObjectTemp = cSecondObject
      else
        return @hMainTaskInfo # [Hash] ��������������ɬ�פʽ���ñ�̾���
      end

      hProcUnitInfo.store(:id, cObjectTemp.sObjectID)
      hProcUnitInfo.store(:prcid, cObjectTemp.hState[TSR_PRM_PRCID])
      hProcUnitInfo.store(:bootcnt, cObjectTemp.hState[TSR_PRM_BOOTCNT])

      return hProcUnitInfo # [Hash] ��������������ɬ�פʽ���ñ�̾���
    end

    #=================================================================
    # ��  ��: �ǥ����ѥå��ػ߾��֤ξ���true��
    #         �����Ǥʤ�����false���֤�
    #=================================================================
    def check_dis_dsp()
      if (!@cCpuState.nil?() && !@cCpuState.hState[TSR_PRM_DISDSP].nil?() && (@cCpuState.hState[TSR_PRM_DISDSP] == true))
        return true # [Bool]�ǥ����ѥå��ػߤξ��
      end

      return false # [Bool]�ǥ����ѥå��ػߤǤʤ����
    end

    #=================================================================
    # ��  ��: �����ͥ���٥ޥ�����������ǤϤʤ�����true��
    #         �����Ǥʤ�����false���֤�
    #=================================================================
    def check_chg_ipm()
      if (!@cCpuState.nil?() && !@cCpuState.hState[TSR_PRM_CHGIPM].nil?() && 
          (@cCpuState.hState[TSR_PRM_CHGIPM] != 0) && (@cCpuState.hState[TSR_PRM_CHGIPM] != KER_TIPM_ENAALL))
        return true # [Bool]�����ͥ���٥ޥ�����������ǤϤʤ����
      end

      return false # [Bool]�����ͥ���٥ޥ�����������ξ��
    end

    #=================================================================
    # ��  ��: CPU��å����֤ξ���true�򡤤����Ǥʤ�����false���֤�
    #=================================================================
    def check_cpu_loc()
      unless (@cCpuState.nil?() || @cCpuState.hState[TSR_PRM_LOCCPU].nil?() || (@cCpuState.hState[TSR_PRM_LOCCPU] != true))
        return true # [Bool] CPU��å����֤ξ��
      end

      return false # [Bool] CPU��å����֤ǤϤʤ����
    end

    #=================================================================
    # ��  ��: ���߼¹Ծ��֤Υ����������Ͼ��֤ξ���true��
    #         �����Ǥʤ�����false���֤�
    #=================================================================
    def check_run_sus()
      if (!@cRunning.nil?())
        if (((@cRunning.sObjectType == TSR_OBJ_TASK) && (@cRunning.hState[TSR_PRM_STATE] == KER_TTS_RUS)) ||
            ((@cRunning.sObjectType == TSR_OBJ_TASK_EXC) && (get_object_info(@cRunning.hState[TSR_PRM_TASK]).hState[TSR_PRM_STATE] == KER_TTS_RUS)))
          return true # [Bool] ���߼¹Ծ��֤Υ����������Ͼ��֤ξ��
        end
      end

      return false # [Bool] ���߼¹Ծ��֤Υ����������Ͼ��֤ǤϤʤ����
    end

    #=================================================================
    # ��  ��: ���߼¹Ծ��֤Υ����������ꤷ��ͥ���٤ξ���true��
    #         �����Ǥʤ�����false���֤�
    #=================================================================
    def check_running_pri(nTaskPri)
      check_class(Integer, nTaskPri)  # �����å�����ͥ����

      if (!@cRunning.nil?())
        # �������ξ��
        if ((@cRunning.sObjectType == TSR_OBJ_TASK) && (@cRunning.hState[TSR_PRM_TSKPRI] == nTaskPri))
          return true # [Bool] ���߼¹Ծ��֤Υ����������ꤷ��ͥ���٤ξ��

        # �������㳰�ξ��
        elsif (@cRunning.sObjectType == TSR_OBJ_TASK_EXC)
          cObjectInfo = get_object_info(@cRunning.hState[TSR_PRM_TASK])
          if (cObjectInfo.hState[TSR_PRM_TSKPRI] == nTaskPri)
            return true # [Bool] ���߼¹Ծ��֤Υ����������ꤷ��ͥ���٤ξ��
          end
        end
      end

      return false # [Bool] ���߼¹Ծ��֤Υ����������ꤷ��ͥ���٤ǤϤʤ����
    end

    #=================================================================
    # ��  ��: ư����֡�Txxx_STA�ˤΥ����।�٥�ȥϥ�ɥ餬�������
    #         true�򡤤����Ǥʤ�����false���֤�
    #=================================================================
    def exist_time_event_sta()
      @hAllObject.each{|sObjectID, cObjectInfo|
        if ((GRP_TIME_EVENT_HDL.include?(cObjectInfo.sObjectType) == true) &&
            (GRP_TIME_EVENT_STA.include?(cObjectInfo.hState[TSR_PRM_STATE]) == true))
          return true # [Bool] ư����֡�Txxx_STA�ˤΥ����।�٥�ȥϥ�ɥ餬������
        end
      }

      return false # [Bool] ư����֡�Txxx_STA�ˤΥ����।�٥�ȥϥ�ɥ餬���ʤ����
    end

    #=================================================================
    # ��  ��: ���ľ��֤γ���ߥϥ�ɥ顤����ߥ����ӥ��롼���󤬤���
    #         ����true�򡤤����Ǥʤ�����false���֤�
    #=================================================================
    def exist_interrupt_ena()
      @hAllObject.each{|sObjectID, cObjectInfo|
        if ((GRP_INTERRUPT.include?(cObjectInfo.sObjectType) == true) && (cObjectInfo.hState[TSR_PRM_STATE] == KER_TA_ENAINT))
          return true # [Bool] ���ľ��֤γ���ߥϥ�ɥ顤����ߥ����ӥ��롼���󤬤�����
        end
      }

      return false # [Bool] ���ľ��֤γ���ߥϥ�ɥ顤����ߥ����ӥ��롼���󤬤��ʤ����
    end

    #=================================================================
    # ��  ��: �¹Ծ��֤Υ������򸡺����Ƥ������true��
    #         �ʤ�����false���֤�
    #=================================================================
    def exist_task_running()
      @hTask.each{|sObjectID, cObjectInfo|
        if (cObjectInfo.hState[TSR_PRM_STATE] == KER_TTS_RUN)
          return true # [Bool] �¹Ծ��֤Υ������򸡺����Ƥ�����
        end
      }

      return false # [Bool] �¹Ծ��֤Υ������򸡺����Ƥʤ����
    end

    #=================================================================
    # ��  ��: ��ư����󥿥����Τ������true��
    #         �ʤ�����false���֤�
    #=================================================================
    def exist_nontask_activate()
      if (!@cActivate.nil?())
        return true # [Bool]��ư����󥿥����Τ�����
      else
        return false # [Bool]��ư����󥿥����Τʤ����
      end
    end

    #=================================================================
    # ��  ��: ��ư�������׵ᥭ�塼���󥰤�����򤷤Ƥ������true��
    #         �����Ǥʤ�����false���֤�
    #=================================================================
    def exist_task_queueing()
      @hTask.each{|sObjectID, cObjectInfo|
        if (!cObjectInfo.hState[TSR_PRM_ACTCNT].nil?() && cObjectInfo.hState[TSR_PRM_ACTCNT] >= 1 || !cObjectInfo.hState[TSR_PRM_WUPCNT].nil?() && cObjectInfo.hState[TSR_PRM_WUPCNT] >= 1)
          return true # [Bool] ��ư�������׵ᥭ�塼���󥰤�����򤷤Ƥ�����
        end
      }

      return false # [Bool] ��ư�������׵ᥭ�塼���󥰤�����򤷤Ƥ��ʤ����

    end

    #=================================================================
    # ��  ��: ���֤�ʤ�������cElement�˳�Ǽ����
    #=================================================================
    def gc_tick_gain(cElement)
      check_class(IMCodeElement, cElement) # �������

      hProcUnitInfo = get_proc_unit_info(@cRunning)

      # ���֤�ʤ�����˥����å��ݥ����
      cElement.set_checkpoint(hProcUnitInfo)
      # ASP�Ǥϥ����ƥ���ﹹ����ǧ�ؿ�����Ѥ���
      cElement.set_code(hProcUnitInfo, "#{FNC_TARGET_GAIN_TICK}()")
    end

    #=================================================================
    # ��  ��: �����֥������Ȥ�ref������IMCodeElement���饹�ˤޤȤ����
    #         ��
    #=================================================================
    def gc_obj_ref()
      cElement      = IMCodeElement.new()
      hProcUnitInfo = get_proc_unit_info(@cActivate, @cRunning)

      # �����Ƚ���
      if (@nSeqNum.nil?() && @nTimeTick.nil?())
        cElement.set_comment(hProcUnitInfo, "#{TSR_LBL_PRE}")
      else
        cElement.set_comment(hProcUnitInfo, "#{TSR_UNS_POST}#{@nSeqNum}_#{@nTimeTick}")
      end

      # �������㳰��ACTIAVTE���ä���硤texptn/exinf�������Ȱ��פ��Ƥ��뤳�Ȥ��ǧ���륳���ɤ������
      if (@cActivate.nil?() && !@cRunning.nil?() && @cRunning.sObjectType == TSR_OBJ_TASK_EXC)
        @cRunning.gc_assert_texptn_exinf(cElement, hProcUnitInfo)
      end

      # ����ߥ����ӥ��롼����ACTIAVTE���ä���硤exinf�������Ȱ��פ��Ƥ��뤳�Ȥ��ǧ���륳���ɤ������
      if (!@cActivate.nil?() && @cActivate.sObjectType == TSR_OBJ_ISR)
        @cActivate.gc_assert_exinf(cElement, hProcUnitInfo)
      end

      # �¹���ν���ñ�̤��ͤ����ꤵ�줿�ѿ�������С����פ��Ƥ��뤳�Ȥ��ǧ���륳���ɤ������
      if (!@cActivate.nil?() && !@cActivate.hState[TSR_PRM_VAR].nil?())
        @cActivate.gc_assert_value(cElement, hProcUnitInfo)
      elsif (!@cRunning.nil?() && !@cRunning.hState[TSR_PRM_VAR].nil?())
        @cRunning.gc_assert_value(cElement, hProcUnitInfo)
      end

      # CPU_STATE��cpu_lock����äƤ��뤫�򻲾�
      bCpuLock = false

      if (!@cCpuState.nil?() && (@cCpuState.hState[TSR_PRM_LOCCPU] == true))
        bCpuLock = true
      end

      # �����֥������Ȥ�ref_code��ޤȤ��
      @hAllObject.each{|sObjectID, cObjectInfo|
        case cObjectInfo.sObjectType
        when TSR_OBJ_CPU_STATE
          cObjectInfo.gc_obj_ref(cElement, hProcUnitInfo)

        when TSR_OBJ_TASK_EXC
          # �������㳰�ϴ�Ϣ�դ����줿���������ٻ߾��֤ξ�硤���ȤǤ��ʤ�
          cTask = get_object_info(cObjectInfo.hState[TSR_PRM_TASK])
          if (cTask.hState[TSR_PRM_STATE] != KER_TTS_DMT)
            cObjectInfo.gc_obj_ref(cElement, hProcUnitInfo, check_activate_context(), bCpuLock)
          end

        # ���֤򻲾ȤǤ��ʤ�����ñ�̤ξ�硤���⤷�ʤ�
        when TSR_OBJ_INTHDR, TSR_OBJ_ISR, TSR_OBJ_EXCEPTION, TSR_OBJ_INIRTN, TSR_OBJ_TERRTN

        else
          cObjectInfo.gc_obj_ref(cElement, hProcUnitInfo, check_activate_context(), bCpuLock)

        end
      }

      cElement.set_checkpoint(hProcUnitInfo)

      return cElement # [IMCodeElement]�������
    end

    #=================================================================
    # ��  ��: ���ꤷ�������פ������֥������Ȥξ�����֤�
    #=================================================================
    def get_all_object_info(sObjectType)
      check_class(String, sObjectType) # �оݤȤ��륪�֥������ȥ�����

      hObjectInfo = Hash.new()
      # �������륪�֥������Ȥξ�����Ǽ����
      @hAllObject.each{|sObjectID, cObjectInfo|
        if (cObjectInfo.sObjectType == sObjectType)
          hObjectInfo[sObjectID] = cObjectInfo
        end
      }

      return hObjectInfo # [Hash]���֥������Ⱦ���ϥå���
    end

    #=================================================================
    # ��  ��: ACTIVATE�Ǥ�����ꤷ������ñ�̤�ID���֤�
    #=================================================================
    def get_activate_proc_unit_id(sObjectType)
      check_class(String, sObjectType) # �оݤȤ��륪�֥������ȥ�����

      aProcUnitID = Array.new()

      # ACTIVATE�Ǥ������ñ�̤ξ�����Ǽ����
      @hAllObject.each{|sObjectID, cObjectInfo|
        if ((cObjectInfo.sObjectType == sObjectType) &&
            (cObjectInfo.hState[TSR_PRM_HDLSTAT] == TSR_STT_ACTIVATE))
          aProcUnitID.push(sObjectID)
        end
      }

      return aProcUnitID # [Array]ACTIVATE�Ǥ������ñ��ID����
    end

    #=================================================================
    # ��  ��: GCOV�������ե饰�����ꤹ��
    #=================================================================
    def set_gcov_all_flg(bFlg)
      check_class(Bool, bFlg) # ���ꤹ��GCOV�������ե饰

      @bGcovAll = bFlg
    end

  end
end
