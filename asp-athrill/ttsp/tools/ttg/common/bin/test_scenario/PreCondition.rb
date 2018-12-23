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
require "common/bin/test_scenario/Condition.rb"
require "ttc/bin/test_scenario/PreCondition.rb"
require "ttj/bin/test_scenario/PreCondition.rb"
require "bin/builder/fmp_builder/test_scenario/PreCondition.rb"

#=====================================================================
# CommonModule
#=====================================================================
module CommonModule
  #===================================================================
  # ���饹̾: PreCondition
  # ��    ��: pre_condition�ξ����������륯�饹
  #===================================================================
  class PreCondition < Condition
    include CommonModule

    attr_reader :hObjectType

    #=================================================================
    # ��  ��: pre_condition�ν����
    #=================================================================
    def initialize(sTestID, hScenarioPre)
      check_class(String, sTestID)           # �ƥ���ID
      check_class(Hash, hScenarioPre, true)  # pre_condition

      super(sTestID)
      @hObjectType = {}  # ���֥�������ID�ȥ����פ��б��դ�

      # ��¤�����å�
      basic_check(hScenarioPre)

      # ���֥�������ID�ȥ��֥������ȥ����פ��б�ɽ����
      hScenarioPre.each{|sObjectID, hObjectInfo|
        @hObjectType[sObjectID] = hObjectInfo[TSR_PRM_TYPE]
      }
      # ���֥������Ⱦ����Ǽ
      store_condition_info(hScenarioPre, @hObjectType)

      # �����å��ֹ�γ�Ǽ
      if (@cConf.is_stack_share_mode?())
        nStackNum = 1
        hObjects = get_objects_by_type(TSR_OBJ_TASK)
        hObjects.each{ |sObjectID, cObjectInfo|
          cObjectInfo.nStackNum = nStackNum
          nStackNum += 1
        }
      end
    end

    #=================================================================
    # ��  ��: pre_condition�ǿʤ���֤�����
    #=================================================================
    def set_pre_gain_tick()
      @nPreGainTick = 0

      # pre_condition��ACTIVATE�ʥ����।�٥�ȥϥ�ɥ��ʤ�뤿���ɬ�פʻ��֤����
      @hAllObject.each{|sObjectID, cObjectInfo|
        if ((GRP_TIME_EVENT_HDL.include?(cObjectInfo.sObjectType) == true) && (cObjectInfo.hState[TSR_PRM_HDLSTAT] == TSR_STT_ACTIVATE))
          if (cObjectInfo.sObjectType == TSR_OBJ_ALARM)
            if (@nPreGainTick == 0)
              @nPreGainTick = 1
            end
          elsif (cObjectInfo.sObjectType == TSR_OBJ_CYCLE)
            if ((cObjectInfo.hState[STR_CYCPHS].to_i + 1) > @nPreGainTick)
              @nPreGainTick = cObjectInfo.hState[STR_CYCPHS].to_i + 1
            end
          end
        end
      }
    end

    #=================================================================
    # ��  ��: �оݥ�������ư���ơ��ᥤ�󥿥�����ͥ���٤򲼤��������
    #         cElement�˳�Ǽ����
    #=================================================================
    def set_act_task(cElement, cObjectInfo)
      check_class(IMCodeElement, cElement)  # �������
      check_class(ProcessUnit, cObjectInfo) # �оݥ��������饹

      hMainTaskInfo = get_proc_unit_info()

      # �оݥ�������ư
      cElement.set_syscall(hMainTaskInfo, "#{API_ACT_TSK}(#{cObjectInfo.sObjectID})")

      # �ᥤ�󥿥�����ͥ���٤򲼤��ƥǥ����ѥå�
      cElement.set_syscall(hMainTaskInfo, "#{API_CHG_PRI}(#{TTG_TSK_SELF}, #{TTG_WAIT_PRI})")

      # �оݥ�������ͥ���٤�TTG_WAIT_PRI��Ʊ�����ä���硤rot_rdq��ȯ�Ԥ��ƥǥ����ѥå�������
      if (cObjectInfo.hState[TSR_PRM_TSKPRI] == TTG_WAIT_PRI)
        cElement.set_syscall(hMainTaskInfo, "#{API_ROT_RDQ}(#{TTG_WAIT_PRI})")
      end
    end
    private :set_act_task

    #=================================================================
    # ��  ��: �ᥤ�󥿥�����ͥ���٤�夲�������
    #         cElement�˳�Ǽ����
    #=================================================================
    def set_chg_pri(cElement)
      check_class(IMCodeElement, cElement) # �������
      hMainTaskInfo = get_proc_unit_info()

      # �ᥤ�󥿥����򸵤�ͥ���٤��᤹
      cElement.set_syscall(hMainTaskInfo, "#{API_CHG_PRI}(#{TTG_TSK_SELF}, #{TTG_MAIN_PRI})")
    end
    private :set_chg_pri

    #=================================================================
    # ��  ��: �������㳰�������ľ��֥��������������true��
    #         �����Ǥʤ�����false���֤�
    #=================================================================
    def exist_pre_task_tex_ena()
      @hTask.each{|sObjectID, cObjectInfo|
        if (!cObjectInfo.cTex.nil?() && cObjectInfo.cTex.hState[TSR_PRM_STATE] == TSR_STT_TTEX_ENA)
          return true # [Bool]�������㳰�������ľ��֥�������������
        end
      }

      return false # [Bool]�������㳰�������ľ��֥����������ʤ����
    end

    #=================================================================
    # ��  ��: ACTIVATE�Ǥ��륿�����㳰�ϥ�ɥ餬�������true��
    #         �����Ǥʤ�����false���֤�
    #=================================================================
    def exist_pre_task_texhdr_activate()
      @hTask.each{|sObjectID, cObjectInfo|
        if (!cObjectInfo.cTex.nil?() && cObjectInfo.cTex.hState[TSR_PRM_HDLSTAT] == TSR_STT_ACTIVATE)
          return true # [Bool]ACTIVATE�Ǥ��륿�����㳰�ϥ�ɥ餬������
        end
      }

      return false # [Bool]ACTIVATE�Ǥ��륿�����㳰�ϥ�ɥ餬���ʤ����
    end

    #=================================================================
    # ��  ��: ������֤����������ɬ�פ�Ʊ�����̿����֥������Ȥ�
    #         �������Ƥ������true�򡤤ʤ�����false���֤�
    #=================================================================
    def exist_pre_scobj_data()
      @hWaitObject.each{|sObjectID, cObjectInfo|
        if (cObjectInfo.hState[TSR_PRM_ISEMCNT] != cObjectInfo.hState[TSR_PRM_SEMCNT]) ||
           (cObjectInfo.hState[TSR_PRM_IFLGPTN] != cObjectInfo.hState[TSR_PRM_FLGPTN]) ||
           !(cObjectInfo.hState[TSR_PRM_DATALIST].nil?() || cObjectInfo.hState[TSR_PRM_DATALIST].empty?()) ||
           !(cObjectInfo.hState[TSR_PRM_MSGLIST].nil?() || cObjectInfo.hState[TSR_PRM_MSGLIST].empty?()) ||
           (cObjectInfo.hState[TSR_PRM_BLKCNT] != cObjectInfo.hState[TSR_PRM_FBLKCNT])
          return true # [Bool]�������Ƥ�����
        end
      }

      return false # [Bool]�������Ƥʤ����
    end

    #=================================================================
    # ��  ��: Ʊ�����̿����֥������Ȥˤ���Ԥ����֤Υ������������
    #         true�򡤤ʤ����false���֤�
    #=================================================================
    def exist_pre_task_scobj_waiting()
      @hTask.each{|sObjectID, cObjectInfo|
        if (!cObjectInfo.hState[TSR_PRM_WOBJID].nil?() && !GRP_WAIT_NON_OBJECT.include?(cObjectInfo.hState[TSR_PRM_WOBJID]))
          return true # [Bool]Ʊ�����̿����֥������Ȥˤ���Ԥ����֤Υ�������������
        end
      }

      return false # [Bool]Ʊ�����̿����֥������Ȥˤ���Ԥ����֤Υ��������ʤ����
    end

    #=================================================================
    # ��  ��: �Ԥ�����(���꡼�ס��ǥ��쥤)�Υ������򸡺����Ƥ������
    #         true�򡤤ʤ�����false���֤�
    #=================================================================
    def exist_pre_task_waiting()
      @hTask.each{|sObjectID, cObjectInfo|
        if (!cObjectInfo.hState[TSR_PRM_WOBJID].nil?() && GRP_WAIT_NON_OBJECT.include?(cObjectInfo.hState[TSR_PRM_WOBJID]))
          return true # [Bool]�������Ƥ�����
        end
      }

      return false # [Bool]�������Ƥʤ����
    end

    #=================================================================
    # ��  ��: �����Ԥ����֤Υ������򸡺����Ƥ������true��
    #         �ʤ�����false���֤�
    #=================================================================
    def exist_pre_task_suspended()
      @hTask.each{|sObjectID, cObjectInfo|
        if (GRP_SUSPENDED.include?(cObjectInfo.hState[TSR_PRM_STATE]))
          return true # [Bool]�������Ƥ�����
        end
      }

      return false # [Bool]�������Ƥʤ����
    end

    #=================================================================
    # ��  ��: ��ǥ������֤Υ������򸡺����Ƥ������true��
    #         �ʤ�����false���֤�
    #=================================================================
    def exist_pre_task_ready()
      @hTask.each{|sObjectID, cObjectInfo|
        if (cObjectInfo.hState[TSR_PRM_STATE] == KER_TTS_RDY)
          return true # [Bool]�������Ƥ�����
        end
      }

      return false # [Bool]�������Ƥʤ����
    end

    #=================================================================
    # ��  ��: ����ͥ���٤Ƚ��ͥ���٤��ۤʤ륿�����򸡺����Ƥ������
    #         true�򡤤ʤ�����false���֤�
    #=================================================================
    def exist_pre_task_pri_chg()
      @hTask.each{|sObjectID, cObjectInfo|
        if ((cObjectInfo.hState[TSR_PRM_STATE] != KER_TTS_RUN) &&
            (cObjectInfo.hState[TSR_PRM_STATE] != KER_TTS_DMT) &&
            (cObjectInfo.hState[TSR_PRM_TSKPRI] != cObjectInfo.hState[TSR_PRM_ITSKPRI]) &&
            !(!cObjectInfo.hState[TSR_PRM_WOBJID].nil?() && !GRP_WAIT_NON_OBJECT.include?(cObjectInfo.hState[TSR_PRM_WOBJID])))
          return true # [Bool]�������Ƥ�����
        end
      }

      return false # [Bool]�������Ƥʤ����
    end

    #=================================================================
    # ��  ��: ��������α�㳰�װ�������򤷤Ƥ������true��
    #         �����Ǥʤ�����false���֤�
    #=================================================================
    def exist_pre_task_tex_pndptn()
      @hTask.each{|sObjectID, cObjectInfo|
        if (!cObjectInfo.cTex.nil?() && !cObjectInfo.cTex.hState[TSR_PRM_PNDPTN].nil?() && cObjectInfo.cTex.hState[TSR_PRM_PNDPTN] != 0)
          return true # [Bool]��������α�㳰�װ�������򤷤Ƥ�����
        end
      }

      return false # [Bool]��������α�㳰�װ�������򤷤Ƥʤ����
    end

    #=================================================================
    # ��  ��: �����Х�/�������ѿ���������뤿��Υ����ɤ�
    #         cElement�˳�Ǽ����
    #=================================================================
    def gc_global_local_var(cElement)
      # �ѿ���¸�ߤ����硤�������
      @hAllObject.each{|sObjectID, cObjectInfo|
        if (!cObjectInfo.hState[TSR_PRM_VAR].nil?())
          cObjectInfo.hState[TSR_PRM_VAR].each{|sValName, cVariable|
            cVariable.gc_global_local_var(cElement, sObjectID)
          }
        end
      }
    end

    #=================================================================
    # ��  ��: �إå����ե�����˽��Ϥ��륳���ɺ���
    #=================================================================
    def gc_header(cElement)
      @hAllObject.each{|sObjectID, cObjectInfo|
        if (GRP_PROCESS_UNIT.include?(cObjectInfo.sObjectType))
          cElement.set_header(sObjectID, cObjectInfo.sObjectType)
        end
      }
    end

    #=================================================================
    # ��  ��: ����ե����ե�����˽��Ϥ��륳���ɺ���
    #=================================================================
    def gc_config(cElement)
      @hAllObject.each{|sObjectID, cObjectInfo|
        # CPU���֤�ɬ�פʤ�
        # �������㳰�ϥ������Ȥν����¸�����뤿�ᡤ��������ǥ����ɤ���������
        # ������롼���󡤽�λ�롼�����¾�Υ����ɤȤޤȤ����������
        # ����ߥϥ�ɥ顤CPU�㳰�϶�ͭ�ؿ��Τ��������������
        if ((cObjectInfo.sObjectType != TSR_OBJ_CPU_STATE) &&
            (cObjectInfo.sObjectType != TSR_OBJ_TASK_EXC) &&
            (cObjectInfo.sObjectType != TSR_OBJ_INIRTN) &&
            (cObjectInfo.sObjectType != TSR_OBJ_TERRTN) &&
            (cObjectInfo.sObjectType != TSR_OBJ_INTHDR) &&
            (cObjectInfo.sObjectType != TSR_OBJ_EXCEPTION))
          cObjectInfo.gc_config(cElement)
        end
      }
    end

    #=================================================================
    # ��  ��: �������㳰�������ľ��֤ˤ��륳���ɤ��֤�
    #=================================================================
    def gc_pre_task_tex_ena()
      cElement = IMCodeElement.new()

      @hTask.each{|sObjectID, cObjectInfo|
        if (!cObjectInfo.cTex.nil?() && cObjectInfo.cTex.hState[TSR_PRM_STATE] == TSR_STT_TTEX_ENA)
          cElement.set_syscall(get_proc_unit_info(get_object_info(sObjectID)), "#{API_ENA_TEX}()")
        end
      }

      return cElement # [IMCodeElement] �������
    end

    #=================================================================
    # ��  ��: �������㳰�����򵯤��������ɤ��֤�
    #=================================================================
    def gc_pre_task_texhdr_activate()
      cElement     = IMCodeElement.new()
      hMainTaskInfo = get_proc_unit_info()
      hRunningTask  = get_proc_unit_info(get_object_info(@cRunning.hState[TSR_PRM_TASK]))
      hActivateTex  = get_proc_unit_info(@cRunning)

      # �¹Ծ��֤Υ�������ư����
      cElement.set_syscall(hMainTaskInfo, "#{API_ACT_TSK}(#{@cRunning.hState[TSR_PRM_TASK]})")

      # �¹Ծ��֤Υ��������������㳰��ư����
      cElement.set_syscall(hRunningTask, "#{API_RAS_TEX}(#{TTG_TSK_SELF}, #{@cRunning.hState[TSR_PRM_TEXPTN]})")

      # �������㳰���ľ��֤�TTEX_DIS�ξ�硤ena_tex����ACTIVATE�ˤ���
      if (@cRunning.hState[TSR_PRM_STATE] == TSR_STT_TTEX_DIS)
        cElement.set_syscall(hRunningTask, "#{API_ENA_TEX}()")
      # �������㳰���ľ��֤�TTEX_ENA�ξ�硤����ena_tex���Ƥ��뤬���������㳰��ư��˺���ena_tex����
      else
        cElement.set_syscall(hActivateTex, "#{API_ENA_TEX}()")
      end

      # ��α�㳰�װ��ѥ�����0�Ǥʤ���硤��ʬ��ras_tex����
      if (@cRunning.hState[TSR_PRM_PNDPTN] != 0)
        cElement.set_syscall(hActivateTex, "#{API_RAS_TEX}(#{TTG_TSK_SELF}, #{@cRunning.hState[TSR_PRM_PNDPTN]})")
      end

      cElement.set_checkpoint(hMainTaskInfo)

      return cElement # [IMCodeElement] �������
    end

    #=================================================================
    # ��  ��: Ʊ�����̿����֥������Ȥν�����֤����������
    #         IMCodeElement���饹�ˤޤȤ���֤�(�ᥤ��ؿ��ν�����ʬ)
    #=================================================================
    def gc_pre_scobj_data()
      # �ᥤ�󥿥��������Ŭ�ڤʽ����ˤ�ꡤ
      # �Ԥ����֥������Ȥν�����֤����ꤹ��
      cElement      = IMCodeElement.new()
      hProcUnitInfo = get_proc_unit_info()

      @hWaitObject.each{|sObjectID, cObjectInfo|
        # SEMAPHORE
        if (cObjectInfo.hState[TSR_PRM_ISEMCNT] != cObjectInfo.hState[TSR_PRM_SEMCNT])
          nTimes = cObjectInfo.hState[TSR_PRM_ISEMCNT] - cObjectInfo.hState[TSR_PRM_SEMCNT]

          if (nTimes > 0)
            nTimes.downto(1){
              cElement.set_syscall(hProcUnitInfo, "#{API_WAI_SEM}(#{cObjectInfo.sObjectID})")
            }
          else
            nTimes.upto(-1){
              cElement.set_syscall(hProcUnitInfo, "#{API_SIG_SEM}(#{cObjectInfo.sObjectID})")
            }
          end
        end

        # EVENTFLAG
        if (cObjectInfo.hState[TSR_PRM_IFLGPTN] != cObjectInfo.hState[TSR_PRM_FLGPTN])
          # ����ӥåȥѥ�����0�Ǥʤ����������ơ�����ӥåȥѥ�����Υե饰�򥯥ꥢ���Ƥ���
          cElement.set_syscall(hProcUnitInfo, "#{API_CLR_FLG}(#{cObjectInfo.sObjectID}, ~#{cObjectInfo.hState[TSR_PRM_IFLGPTN]})")
          cElement.set_syscall(hProcUnitInfo, "#{API_SET_FLG}(#{cObjectInfo.sObjectID}, #{cObjectInfo.hState[TSR_PRM_FLGPTN]})")
        end

        # DATAQUEUE��P_DATAQUEUE
        if !(cObjectInfo.hState[TSR_PRM_DATALIST].nil?() || cObjectInfo.hState[TSR_PRM_DATALIST].empty?())
          cObjectInfo.hState[TSR_PRM_DATALIST].each{|hData|
            case cObjectInfo.sObjectType
            when TSR_OBJ_DATAQUEUE
              cElement.set_syscall(hProcUnitInfo, "#{API_SND_DTQ}(#{cObjectInfo.sObjectID}, #{hData[TSR_VAR_DATA]})")

            when TSR_OBJ_P_DATAQUEUE
              cElement.set_syscall(hProcUnitInfo, "#{API_SND_PDQ}(#{cObjectInfo.sObjectID}, #{hData[TSR_VAR_DATA]}, #{hData[TSR_VAR_DATAPRI]})")

            end
          }
        end

        # MAILBOX
        if !(cObjectInfo.hState[TSR_PRM_MSGLIST].nil?() || cObjectInfo.hState[TSR_PRM_MSGLIST].empty?())
          cObjectInfo.hState[TSR_PRM_MSGLIST].each{|hData|
            if (hData.has_key?(TSR_VAR_MSGPRI))
              cElement.set_global_var(hData[TSR_VAR_MSG], TYP_T_MSG_PRI)
              cElement.set_code(hProcUnitInfo, "#{hData[TSR_VAR_MSG]}.#{STR_MSGPRI} = #{hData[TSR_VAR_MSGPRI]}")
              cElement.set_syscall(hProcUnitInfo, "#{API_SND_MBX}(#{cObjectInfo.sObjectID}, #{CST_MSG1}&#{hData[TSR_VAR_MSG]})")
            else
              cElement.set_global_var(hData[TSR_VAR_MSG], TYP_T_MSG)
              cElement.set_syscall(hProcUnitInfo, "#{API_SND_MBX}(#{cObjectInfo.sObjectID}, &#{hData[TSR_VAR_MSG]})")
            end
          }
        end

        # MEMORYPOOL
        if (cObjectInfo.hState[TSR_PRM_BLKCNT] != cObjectInfo.hState[TSR_PRM_FBLKCNT])
          nTimes = cObjectInfo.hState[TSR_PRM_BLKCNT] - cObjectInfo.hState[TSR_PRM_FBLKCNT]

          (1..nTimes).each{|nCnt|
            cElement.set_local_var(hProcUnitInfo[:id], "#{VAR_BLK}_#{nCnt}", TYP_VOID_P)
            cElement.set_syscall(hProcUnitInfo, "#{API_GET_MPF}(#{cObjectInfo.sObjectID}, &#{VAR_BLK}_#{nCnt})")
          }
        end
      }

      cElement.set_checkpoint(hProcUnitInfo)

      return cElement # [IMCodeElement] �������
    end

    #=================================================================
    # ��  ��: Ʊ�����̿����֥������Ȥˤ���Ԥ����֥������ν�����֤�
    #         ���������IMCodeElement���饹�ˤޤȤ���֤�
    #=================================================================
    def gc_pre_task_scobj_waiting()
      # �������򥪥֥��������Ԥ��ˤ��륳���ɥ֥�å����֤�
      # ���ASP_dataqueue_rcv_dtq_f_2_1_1
      #   �ᥤ�󥿥�����TASK2�򵯤������������㳰�ϥ�ɥ餬¸�ߤ������
      #   ����������򤷡�TASK2��ʬ��snd_dtq������
      #   �����Ԥ��ˤ�����(����������Ԥ��ˤʤäƤ��륿�����ο�����)
      cElement      = IMCodeElement.new()
      hMainTaskInfo = get_proc_unit_info()

      @hWaitObject.each{|sObjectID, cObjectInfo|
        # �Ԥ��������Υꥹ��
        if (!cObjectInfo.hState[TSR_PRM_WTSKLIST].nil?() && !cObjectInfo.hState[TSR_PRM_WTSKLIST].empty?())
          cObjectInfo.hState[TSR_PRM_WTSKLIST].each{|aWtskList|
            aWtskList.each_key{|sTaskID|
              cTaskInfo = @hTask[sTaskID]

              # �оݥ������إǥ����ѥå����뤿��Υ�����
              set_act_task(cElement, cTaskInfo)

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

              # �ᥤ�󥿥�����ͥ���٤��᤹����Υ�����
              set_chg_pri(cElement)

              # �оݥ������θ���ͥ���٤Ƚ��ͥ���٤��ۤʤ��礳����chg_pri����
              # (Ʊ���̿����֥������Ȥ�°����ͥ���ٽ���ä����ˡ��Ԥ���Ǥʤ��Ƚ�����Ѥ���ǽ��������)
              if (cTaskInfo.hState[TSR_PRM_TSKPRI] != cTaskInfo.hState[TSR_PRM_ITSKPRI])
                cElement.set_syscall(hMainTaskInfo, "#{API_CHG_PRI}(#{cTaskInfo.sObjectID}, #{cTaskInfo.hState[TSR_PRM_TSKPRI]})")
              end
            }
          }
        end

        # �����Ԥ��������Υꥹ��
        if (!cObjectInfo.hState[TSR_PRM_STSKLIST].nil?() && !cObjectInfo.hState[TSR_PRM_STSKLIST].empty?())
          cObjectInfo.hState[TSR_PRM_STSKLIST].each{|aStskList|
            aStskList.each{|sTaskID, hData|
              cTaskInfo = @hTask[sTaskID]

              # �оݥ������إǥ����ѥå����뤿��Υ�����
              set_act_task(cElement, cTaskInfo)

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

              # �ᥤ�󥿥�����ͥ���٤��᤹����Υ�����
              set_chg_pri(cElement)

              # �оݥ������θ���ͥ���٤Ƚ��ͥ���٤��ۤʤ��礳����chg_pri����
              # (Ʊ���̿����֥������Ȥ�°����ͥ���ٽ���ä����ˡ��Ԥ���Ǥʤ��Ƚ�����Ѥ���ǽ��������)
              if (cTaskInfo.hState[TSR_PRM_TSKPRI] != cTaskInfo.hState[TSR_PRM_ITSKPRI])
                cElement.set_syscall(hMainTaskInfo, "#{API_CHG_PRI}(#{cTaskInfo.sObjectID}, #{cTaskInfo.hState[TSR_PRM_TSKPRI]})")
              end
            }
          }
        end

        # �����Ԥ��������Υꥹ��
        if (!cObjectInfo.hState[TSR_PRM_RTSKLIST].nil?() && !cObjectInfo.hState[TSR_PRM_RTSKLIST].empty?())
          cObjectInfo.hState[TSR_PRM_RTSKLIST].each{|aRtskList|
            aRtskList.each_key{|sTaskID|
              cTaskInfo = @hTask[sTaskID]

              # �оݥ������إǥ����ѥå����뤿��Υ�����
              set_act_task(cElement, cTaskInfo)

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

              # �ᥤ�󥿥�����ͥ���٤��᤹����Υ�����
              set_chg_pri(cElement)

              # �оݥ������θ���ͥ���٤Ƚ��ͥ���٤��ۤʤ��礳����chg_pri����
              # (Ʊ���̿����֥������Ȥ�°����ͥ���ٽ���ä����ˡ��Ԥ���Ǥʤ��Ƚ�����Ѥ���ǽ��������)
              if (cTaskInfo.hState[TSR_PRM_TSKPRI] != cTaskInfo.hState[TSR_PRM_ITSKPRI])
                cElement.set_syscall(hMainTaskInfo, "#{API_CHG_PRI}(#{cTaskInfo.sObjectID}, #{cTaskInfo.hState[TSR_PRM_TSKPRI]})")
              end
            }
          }
        end
      }

      # �Ԥ����ֺ����塤�ᥤ�󥿥�������ä������ǥ����å��ݥ����
      cElement.set_checkpoint(get_proc_unit_info())

      return cElement # [IMCodeElement] �������
    end

    #=================================================================
    # ��  ��: �Ԥ����֤Ǥ��륿�����ν�����֤����������
    #         IMCodeElement���饹�ˤޤȤ���֤�
    #=================================================================
    def gc_pre_task_waiting()
      cElement = IMCodeElement.new()

      @hTask.each{|sObjectID, cObjectInfo|
        if (GRP_WAIT_NON_OBJECT.include?(cObjectInfo.hState[TSR_PRM_WOBJID]))
          # �оݥ������إǥ����ѥå����뤿��Υ�����
          set_act_task(cElement, cObjectInfo)

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

          # �ᥤ�󥿥�����ͥ���٤��᤹����Υ�����
          set_chg_pri(cElement)
        end
      }

      # �Ԥ����ֺ����塤�ᥤ�󥿥�������ä������ǥ����å��ݥ����
      cElement.set_checkpoint(get_proc_unit_info())

      return cElement # [IMCodeElement] �������
    end

    #=================================================================
    # ��  ��: �������֤Ǥ��륿�����ν�����֤����������
    #         IMCodeElement���饹�ˤޤȤ���֤�
    #=================================================================
    def gc_pre_task_suspended()
      # �ᥤ�󥿥�����sus_tsk(�оݥ�����)����
      cElement      = IMCodeElement.new()
      hMainTaskInfo = get_proc_unit_info()

      @hTask.each{|sObjectID, cObjectInfo|
        if (GRP_SUSPENDED.include?(cObjectInfo.hState[TSR_PRM_STATE]))  # TTS_SUS��TTS_WAS
          if (cObjectInfo.hState[TSR_PRM_STATE] == KER_TTS_SUS)
            # �оݥ������إǥ����ѥå����뤿��Υ�����
            set_act_task(cElement, cObjectInfo)

            # �оݥ������ξ�������������å��ݥ��������
            hProcUnitInfo = get_proc_unit_info(cObjectInfo)
            cElement.set_checkpoint(hProcUnitInfo)

            cElement.set_syscall(hProcUnitInfo, "#{API_SLP_TSK}()")

            # �ᥤ�󥿥�����ͥ���٤��᤹����Υ�����
            set_chg_pri(cElement)
          end

          cElement.set_syscall(hMainTaskInfo, "#{API_SUS_TSK}(#{sObjectID})")

          # �����Ԥ��ξ�硤�������ƴ���
          if (cObjectInfo.hState[TSR_PRM_STATE] == KER_TTS_SUS)
            cElement.set_syscall(hMainTaskInfo, "#{API_WUP_TSK}(#{sObjectID})")
          end
        end
      }

      cElement.set_checkpoint(hMainTaskInfo)

      return cElement # [IMCodeElement] �������
    end

    #=================================================================
    # ��  ��: ��ǥ������֤Ǥ��륿�����ν�����֤����������
    #         IMCodeElement���饹�ˤޤȤ���֤�
    #=================================================================
    def gc_pre_task_ready()
      cElement      = IMCodeElement.new()
      hMainTaskInfo = get_proc_unit_info()

      # �ᥤ�󥿥������鵯�����ơ�����������slp_tsk���Ƥ���
      @hTask.each{|sObjectID, cObjectInfo|
        if (cObjectInfo.hState[TSR_PRM_STATE] == KER_TTS_RDY)
          # �оݥ������إǥ����ѥå����뤿��Υ�����
          set_act_task(cElement, cObjectInfo)

          # �оݥ������ξ�������������å��ݥ��������
          hProcUnitInfo = get_proc_unit_info(cObjectInfo)
          cElement.set_checkpoint(hProcUnitInfo)

          cElement.set_syscall(hProcUnitInfo, "#{API_SLP_TSK}()")

          # �ᥤ�󥿥�����ͥ���٤��᤹����Υ�����
          set_chg_pri(cElement)
        end
      }

      cElement.set_checkpoint(hMainTaskInfo)

      return cElement # [IMCodeElement] �������
    end

    #=================================================================
    # ��  ��: ��������α�㳰�װ������ꤹ�륳���ɤ��֤�
    #=================================================================
    def gc_pre_task_tex_pndptn()
      cElement      = IMCodeElement.new()
      hMainTaskInfo = get_proc_unit_info()

      @hTask.each{|sObjectID, cObjectInfo|
        # ���������¹���⤷���ϥ������㳰�ϥ�ɥ餬ACTIVATE�ξ��ϡ���ʬ���Ȥ�ras_tex����
        if (!GRP_ACTIVATE.include?(cObjectInfo.hState[TSR_PRM_STATE]) && (!cObjectInfo.cTex.nil?()) &&
            !cObjectInfo.cTex.hState[TSR_PRM_PNDPTN].nil?() && (cObjectInfo.cTex.hState[TSR_PRM_PNDPTN] != 0))
          cElement.set_syscall(hMainTaskInfo, "#{API_RAS_TEX}(#{sObjectID}, #{cObjectInfo.cTex.hState[TSR_PRM_PNDPTN]})")
        end
      }

      cElement.set_checkpoint(hMainTaskInfo)

      return cElement # [IMCodeElement] �������
    end

    #=================================================================
    # ��  ��: ư�����(Txxx_STA)�Υ����।�٥�ȥϥ�ɥ�����ꤹ��
    #         �����ɤ��֤�
    #=================================================================
    def gc_pre_time_event_sta()
      cElement      = IMCodeElement.new()
      hMainTaskInfo = get_proc_unit_info()

      @hAllObject.each{|sObjectID, cObjectInfo|
        if ((GRP_TIME_EVENT_HDL.include?(cObjectInfo.sObjectType) == true) &&
            (GRP_TIME_EVENT_STA.include?(cObjectInfo.hState[TSR_PRM_STATE]) == true) &&
             (cObjectInfo.hState[TSR_PRM_HDLSTAT] != TSR_STT_ACTIVATE))
          if (cObjectInfo.sObjectType == TSR_OBJ_ALARM)
            cElement.set_syscall(hMainTaskInfo, "#{API_STA_ALM}(#{sObjectID}, #{cObjectInfo.hState[TSR_PRM_LEFTTMO].to_i + @nPreGainTick})")
          elsif (cObjectInfo.sObjectType == TSR_OBJ_CYCLE)
            cElement.set_syscall(hMainTaskInfo, "#{API_STA_CYC}(#{sObjectID})")
          end
        end
      }

      cElement.set_checkpoint(hMainTaskInfo)

      return cElement # [IMCodeElement] �������
    end

    #=================================================================
    # ��  ��: ���ľ��֤γ���ߤ����ꤹ�륳���ɤ��֤�
    #=================================================================
    def gc_pre_interrupt_ena()
      cElement      = IMCodeElement.new()
      hMainTaskInfo = get_proc_unit_info()

      # ena_int����ɬ�פΤ��������ֹ�����
      aEnaIntNo = []
      @hAllObject.each{|sObjectID, cObjectInfo|
        if ((GRP_INTERRUPT.include?(cObjectInfo.sObjectType) == true) &&
            (cObjectInfo.hState[TSR_PRM_STATE] == KER_TA_ENAINT))
          aEnaIntNo.push(cObjectInfo.hState[TSR_PRM_INTNO])
        end
      }

      # ��ʣ�������Ƥ��٤�ena_int��¹Ԥ���
      aEnaIntNo.uniq!()
      aEnaIntNo.each{|snIntNo|
        cElement.set_syscall(hMainTaskInfo, "#{API_ENA_INT}(#{snIntNo})")
      }

      cElement.set_checkpoint(hMainTaskInfo)

      return cElement # [IMCodeElement] �������
    end

    #=================================================================
    # ��  ��: ����ͥ���٤Ƚ��ͥ���٤��ۤʤ륿���������������
    #         IMCodeElement���饹�ˤޤȤ���֤�
    #         (running,dormant,running-suspend,���֥��������Ԥ��ʳ��Υ�����)
    #=================================================================
    def gc_pre_task_pri_chg()
      cElement      = IMCodeElement.new()
      hMainTaskInfo = get_proc_unit_info()

      @hTask.each{|sObjectID, cObjectInfo|
        if ((cObjectInfo.hState[TSR_PRM_STATE] != KER_TTS_RUN) &&
            (cObjectInfo.hState[TSR_PRM_STATE] != KER_TTS_RUS) &&
            (cObjectInfo.hState[TSR_PRM_STATE] != KER_TTS_DMT) &&
            (cObjectInfo.hState[TSR_PRM_TSKPRI] != cObjectInfo.hState[TSR_PRM_ITSKPRI]) &&
            !(!cObjectInfo.hState[TSR_PRM_WOBJID].nil?() && !GRP_WAIT_NON_OBJECT.include?(cObjectInfo.hState[TSR_PRM_WOBJID])))
          cElement.set_syscall(hMainTaskInfo, "#{API_CHG_PRI}(#{sObjectID}, #{cObjectInfo.hState[TSR_PRM_TSKPRI]})")
        end
      }

      cElement.set_checkpoint(hMainTaskInfo)

      return cElement # [IMCodeElement] �������
    end

    #=================================================================
    # ��  ��: �¹Ծ��֤Ǥ��륿�����ν�����֤����������
    #         IMCodeElement���饹�ˤޤȤ���֤�
    #=================================================================
    def gc_pre_task_running()
      # �¹Ծ��֤ˤʤ�٤��Υ�������ᥤ�󥿥������鵯����
      cElement      = IMCodeElement.new()
      hMainTaskInfo = get_proc_unit_info()

      cElement.set_syscall(hMainTaskInfo, "#{API_ACT_TSK}(#{@cRunning.sObjectID})")

      # ��������α�㳰�װ�����������ꤹ��
      if (!@cRunning.cTex.nil?() && 
          !@cRunning.cTex.hState[TSR_PRM_PNDPTN].nil?() && 
          @cRunning.cTex.hState[TSR_PRM_PNDPTN] != 0 &&
          @cRunning.cTex.hState[TSR_PRM_HDLSTAT] != TSR_STT_ACTIVATE)
        cElement.set_syscall(hMainTaskInfo, "#{API_RAS_TEX}(#{@cRunning.sObjectID}, #{@cRunning.cTex.hState[TSR_PRM_PNDPTN]})")
      end

      # ����ͥ���٤Ƚ��ͥ���٤��ۤʤ�����ꤹ��
      if (@cRunning.hState[TSR_PRM_TSKPRI] != @cRunning.hState[TSR_PRM_ITSKPRI])
        cElement.set_syscall(hMainTaskInfo, "#{API_CHG_PRI}(#{@cRunning.sObjectID}, #{@cRunning.hState[TSR_PRM_TSKPRI]})")
      end

      cElement.set_checkpoint(hMainTaskInfo)

      return cElement # [IMCodeElement] �������
    end

    #=================================================================
    # ��  ��: �ǥ����ѥå��ػߤˤ����������
    #         IMCodeElement���饹�ˤޤȤ���֤�
    #=================================================================
    def gc_pre_dis_dsp()
      cElement      = IMCodeElement.new()
      hProcUnitInfo = get_proc_unit_info(@cRunning)

      cElement.set_syscall(hProcUnitInfo, "#{API_DIS_DSP}()")

      return cElement # [IMCodeElement] �������
    end

    #=================================================================
    # ��  ��: �����ͥ���٥ޥ�����0�ʳ��ˤ����������
    #         IMCodeElement���饹�ˤޤȤ���֤�
    #=================================================================
    def gc_pre_set_ipm()
      cElement      = IMCodeElement.new()
      hProcUnitInfo = get_proc_unit_info(@cRunning)

      cElement.set_syscall(hProcUnitInfo, "#{API_CHG_IPM}(#{@cCpuState.hState[TSR_PRM_CHGIPM]})")

      return cElement # [IMCodeElement] �������
    end

    #=================================================================
    # ��  ��: ��ư����󥿥��������������
    #         IMCodeElement���饹�ˤޤȤ���֤�
    #=================================================================
    def gc_pre_nontask_activate()
      cElement      = IMCodeElement.new()
      hProcUnitInfo = get_proc_unit_info(@cRunning)

      case @cActivate.sObjectType
      # ���顼��ϥ�ɥ�
      when TSR_OBJ_ALARM
        # 0�ä����ꤷ��1�ߥ��ÿʤ�Ƶ�ư����
        cElement.set_syscall(hProcUnitInfo, "#{API_STA_ALM}(#{@cActivate.sObjectID}, 0)")
        # STA°��������м��Ȥ���ista_alm��¹Ԥ���
        if (@cActivate.hState[TSR_PRM_STATE] == TSR_STT_TALM_STA)
          cElement.set_syscall(get_proc_unit_info(@cActivate), "#{API_ISTA_ALM}(#{@cActivate.sObjectID}, #{@cActivate.hState[TSR_PRM_LEFTTMO]})")
        end
        gc_tick_gain(cElement)

      # �����ϥ�ɥ�
      when TSR_OBJ_CYCLE
        cElement.set_syscall(hProcUnitInfo, "#{API_STA_CYC}(#{@cActivate.sObjectID})")
        # �����ʬ�������֤�ʤ�Ƶ�ư����
        (@cActivate.hState[TSR_PRM_CYCPHS].to_i + 1).times{
          gc_tick_gain(cElement)
        }

      # ����ߥϥ�ɥ顤����ߥ����ӥ��롼����
      when TSR_OBJ_INTHDR, TSR_OBJ_ISR
        # �����ȯ���ؿ���¹Ԥ��Ƶ�ư����
        cElement.set_code(hProcUnitInfo, "#{FNC_INT_RAISE}(#{@cActivate.hState[TSR_PRM_INTNO]})")

      # CPU�㳰�ϥ�ɥ�
      when TSR_OBJ_EXCEPTION
        # CPU�㳰ȯ���ؿ���¹Ԥ��Ƶ�ư����
        cElement.set_code(hProcUnitInfo, "#{FNC_CPUEXC_RAISE}(#{@cActivate.hState[TSR_PRM_EXCNO]})")

      else
        abort(ERR_MSG % [__FILE__, __LINE__])
      end

      # �����ƥ���ﹹ��/�����/CPU�㳰ȯ�����ٱ䤷������������
      # �󥿥���¦�ǥ����å��ݥ���Ȥ�ȯ�Ԥ���ȯ�Ը��ǥ����å��ݥ���Ȥ��Ԥ�
      cElement.set_checkpoint(get_proc_unit_info(@cActivate))
      cElement.wait_checkpoint(hProcUnitInfo)

      return cElement # [IMCodeElement] �������
    end

    #=================================================================
    # ��  ��: ���Ū��SLEEP�ޤ���DELAY��������������¹Խ��֤˵�����
    #         ������IMCodeElement���饹�ˤޤȤ���֤�
    #=================================================================
    def gc_pre_task_ready_porder()
      # ������꡼�פ����Ƥ�������������porder���ǧ����
      # �¹Բ�ǽ���֤ˤ�����

      cElement  = IMCodeElement.new()  # element���饹���Ѱդ���

      aPriorityTemp = []  # ͥ���̤Τʤ����������ݻ����뤿�������
      aPriOrderTemp = []  # ͥ���̤Τ��륿������ͥ�����ݻ����뤿�������

      @hTask.each{|sObjectID, cObjectInfo|
        if (cObjectInfo.hState[TSR_PRM_STATE] == KER_TTS_RDY)
          nPOrder = cObjectInfo.hState[TSR_PRM_PORDER]

          if (nPOrder.nil?())
            aPriorityTemp.push(sObjectID)
          else
            aPriOrderTemp[nPOrder] = sObjectID  # ͥ���̤ν������
          end
        end
      }

      aPriOrderTemp.delete(nil)  # ɬ�פǤϤʤ�nil�Ϻ��
      aPriOrderTemp = aPriOrderTemp.concat(aPriorityTemp)
      hProcUnitInfo = get_proc_unit_info(@cActivate, @cRunning)

      aPriOrderTemp.each{|sObjectID|
        # �¹Ծ��֤��󥿥�����������
        if (!@cActivate.nil?())
          cElement.set_syscall(hProcUnitInfo, "#{API_IWUP_TSK}(#{sObjectID})")
        # �¹Ծ��֤Υ�������������
        elsif (!@cRunning.nil?())
          cElement.set_syscall(hProcUnitInfo, "#{API_WUP_TSK}(#{sObjectID})")
        else
          abort(ERR_MSG % [__FILE__, __LINE__])
        end
      }

      cElement.set_checkpoint(hProcUnitInfo)

      return cElement # [IMCodeElement] �������
    end

    #=================================================================
    # ��  ��: ��ư�������׵ᥭ�塼���󥰤�����򤹤������
    #         IMCodeElement���饹�ˤޤȤ���֤�
    #=================================================================
    def gc_pre_task_queueing()
      cElement      = IMCodeElement.new()  # element���饹���Ѱդ���
      hProcUnitInfo = get_proc_unit_info(@cActivate, @cRunning)

      @hTask.each{|sObjectID, cObjectInfo|
        if (!cObjectInfo.hState[TSR_PRM_ACTCNT].nil?() && cObjectInfo.hState[TSR_PRM_ACTCNT] >= 1)
          cObjectInfo.hState[TSR_PRM_ACTCNT].times{
            if (!@cActivate.nil?())
              cElement.set_syscall(hProcUnitInfo, "#{API_IACT_TSK}(#{sObjectID})")
            elsif (!@cRunning.nil?())
              cElement.set_syscall(hProcUnitInfo, "#{API_ACT_TSK}(#{sObjectID})")
            else
              abort(ERR_MSG % [__FILE__, __LINE__])
            end
          }
        end

        if(!cObjectInfo.hState[TSR_PRM_WUPCNT].nil?() && cObjectInfo.hState[TSR_PRM_WUPCNT] >= 1)
          cObjectInfo.hState[TSR_PRM_WUPCNT].times{
            if (!@cActivate.nil?())
              cElement.set_syscall(hProcUnitInfo, "#{API_IWUP_TSK}(#{sObjectID})")
            elsif (!@cRunning.nil?())
              cElement.set_syscall(hProcUnitInfo, "#{API_WUP_TSK}(#{sObjectID})")
            else
              abort(ERR_MSG % [__FILE__, __LINE__])
            end
          }
        end
      }

      cElement.set_checkpoint(hProcUnitInfo)

      return cElement # [IMCodeElement] �������
    end

    #=================================================================
    # ��  ��: CPU��å����֤�����(�¹���ν���ñ�̤�������)������
    #         IMCodeElement���饹�ˤޤȤ���֤�
    #=================================================================
    def gc_pre_cpu_loc()
      # ��ư���֤��󥿥����������硤���顼�ࡦ�����ϥ�ɥ�ξ��
      # ������ϥ��顼��ˤ�����
      # �ޤ�����ư���֤��󥿥��������ʤ������ļ¹Ծ��֤Υ�������
      # ������ϡ��������ˤ�����

      cElement      = IMCodeElement.new()
      hProcUnitInfo = get_proc_unit_info(@cActivate, @cRunning)

      if (!@cActivate.nil?())
        cElement.set_syscall(hProcUnitInfo, "#{API_ILOC_CPU}()")
      else
        cElement.set_syscall(hProcUnitInfo, "#{API_LOC_CPU}()")
      end

      cElement.set_checkpoint(hProcUnitInfo)

      return cElement # [IMCodeElement] �������
    end

    #=================================================================
    # ��  ��: ���ξ��֤�����������˹Ԥ��٤��Υᥤ������������
    #         IMCodeElement���饹�ˤޤȤ���֤�
    #=================================================================
    def gc_pre_maintask_set(cNextActivate, cNextRunning, bNextCpuLock, bNextRunSus)
      check_class(ProcessUnit, cNextActivate, true) # ���Υ���ǥ������ǵ�ư��ν���ñ��
      check_class(ProcessUnit, cNextRunning, true)  # ���Υ���ǥ������Ǽ¹���Υ�����
      check_class(Bool, bNextCpuLock)               # ���Υ���ǥ�������CPU��å���
      check_class(Bool, bNextRunSus)                # ���Υ���ǥ������ǲ��Ͼ��֤��ɤ���

      cElement      = IMCodeElement.new()
      hMainTaskInfo = get_proc_unit_info()

      # ���Υ���ǥ������˼¹Ծ��֤ν���ñ�̤�¸�ߤ�����
      # pre_condition���󥿥�����ACTIVATE���ä����ϡ�
      # �ᥤ�󥿥�����slp_tsk���ơ��󥿥�������iwup_tsk�ǵ�����
      # (�󥿥�����ư���˥ᥤ�󥿥����ν������ʤ�Τ��򤱤�)
      if (!@cActivate.nil?() && @cRunning.nil?() && cNextActivate.nil?() && cNextRunning.nil?())
        cElement.set_syscall(hMainTaskInfo, "#{API_SLP_TSK}()")
        cElement.set_syscall(get_proc_unit_info(@cActivate), "#{API_IWUP_TSK}(#{TTG_MAIN_TASK})")
        @lMainTaskState = :running

      # ���ξ��򤹤٤���������硤���Υ���ǥ�������
      # �ᥤ�󥿥����򵯾��Ǥ��뤿�ᡤslp_tsk����
      # 1)���Υ���ǥ������˼¹Ծ��֤ν���ñ�̤�¸�ߤ���
      # 2)���Υ���ǥ������μ¹Ծ��֤Υ����������Ͼ��֤Ǥʤ�
      #   (������ǲ��Ͼ��֤������������Ƕ����Ԥ��Ȥʤꡤ�ᥤ�󥿥����򵯾��Ǥ��ʤ�)
      # 3)���Υ���ǥ������CPU��å��Ǥʤ�
      #   (ʣ����do/post��³�����������chg_pri/wup_tsk��ȯ�ԤǤ��ʤ���ǽ��������)
      elsif ((!cNextActivate.nil?() || !cNextRunning.nil?()) && (bNextRunSus == false) && (bNextCpuLock == false))
        cElement.set_syscall(hMainTaskInfo, "#{API_SLP_TSK}()")
        @lMainTaskState = :sleep

      # �嵭�ʳ��Ǥϥᥤ��ץ��å��򵯾��Ǥ��ʤ���ǽ�������뤿�ᡤ
      # �¹���Υ�������¸�ߤ����硤�ᥤ�󥿥�����ͥ���٤򲼤��Ƥ���
      elsif (!@cRunning.nil?())
        cElement.set_syscall(hMainTaskInfo, "#{API_CHG_PRI}(#{TTG_TSK_SELF}, #{TTG_WAIT_PRI})")
        # pre_condition��running�Υ�����ͥ���٤�TTG_WAIT_PRI���ä����
        if (check_running_pri(TTG_WAIT_PRI) == true)
          cElement.set_syscall(hMainTaskInfo, "#{API_ROT_RDQ}(#{TTG_WAIT_PRI})")
        end
        # �ᥤ�󥿥���������TTG_MAIN_PRI�ξ���chg_pri��ȯ�Ԥ��ʤ�
        cElement.set_chg_pri_main_task(hMainTaskInfo)

        @lMainTaskState = :ready

      # �嵭�ʳ��ϲ��⤷�ʤ�
      else
        @lMainTaskState = :running

      end

      return cElement # [IMCodeElement] �������
    end

    #=================================================================
    # ��  ��: �����ͥ���٥ޥ��������ɬ�������������true��
    #         �ʤ�����false���֤�
    #=================================================================
    def check_pre_need_chg_ipm()
      # �����ͥ���٥ޥ��������ꤵ��Ƥ��ʤ�����false���֤�
      if (check_chg_ipm() == false)
        return false # [Bool] �����ͥ���٥ޥ��������ɬ����̵ͭ
      end

      # �ʲ��Τ����줫�����������Τ߳����ͥ���٥ޥ������ѹ�����
      # 1)ACTIVATE���󥿥�����¸�ߤ��ʤ�
      # 2)ACTIVATE���󥿥�����CPU�㳰�ϥ�ɥ�Ǥ���
      if (@cActivate.nil?() || (@cActivate.sObjectType == TSR_OBJ_EXCEPTION))
        return true # [Bool] �����ͥ���٥ޥ��������ɬ����̵ͭ
      else
        return false # [Bool] �����ͥ���٥ޥ��������ɬ����̵ͭ
      end
    end

    #=================================================================
    # ��  ��: �����/��λ�롼���󥯥饹�������ID������������֤�
    #=================================================================
    def get_ini_ter_object_info_sort_by_id(sObjectType)
      check_class(String, sObjectType)  # �оݤȤ��륪�֥������ȥ�����[�����or��λ�롼����]

      aIniTerInfo = []
      @hAllObject.sort.each{|aObjectInfo|
        if (aObjectInfo[1].sObjectType == sObjectType)
          aIniTerInfo.push(aObjectInfo[1])
        end
      }

      return aIniTerInfo  # [Array]�����/��λ�롼���󥯥饹������
    end

    #=================================================================
    # ��  ��: TA_STA°���μ����ϥ�ɥ��̵ͭ���֤�
    #=================================================================
    def exist_cyclic_sta()
      @hAllObject.each{|sObjID, cObjectInfo|
        if ((cObjectInfo.sObjectType == TSR_OBJ_CYCLE) && (cObjectInfo.hState[TSR_PRM_ATR] == KER_TA_STA))
          return true    # [Bool]TA_STA°���μ����ϥ�ɥ餬¸�ߤ���
        end
      }

      return false  # [Bool]TA_STA°���μ����ϥ�ɥ餬¸�ߤ��ʤ�
    end

    #=================================================================
    # ��  ��: TA_ENAINT°���γ���ߥ����ӥ��롼�����̵ͭ���֤�
    #=================================================================
    def exist_isr_enaint()
      @hAllObject.each{|sObjID, cObjectInfo|
        if ((cObjectInfo.sObjectType == TSR_OBJ_ISR) && (cObjectInfo.hState[TSR_PRM_ATR] == KER_TA_ENAINT))
          return true    # [Bool]TA_ENAINT°���γ���ߥ����ӥ��롼����¸�ߤ���
        end
      }

      return false  # [Bool]TA_ENAINT°���γ���ߥ����ӥ��롼����¸�ߤ��ʤ�
    end
  end
end
