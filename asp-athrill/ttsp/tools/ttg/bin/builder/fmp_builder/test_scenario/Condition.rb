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
#  $Id: Condition.rb 11 2012-10-25 09:29:59Z nces-shigihara $
#

#=====================================================================
# CommonModule
#=====================================================================
module CommonModule
  #===================================================================
  # ���饹̾: Condition
  # ��    ��: pre_condition, post_condition�ξ����������륯�饹
  #===================================================================
  class Condition

    #=================================================================
    # ��  ��: �¹Ծ��֤Υ��������������true��
    #         �ʤ�����false���֤�
    #=================================================================
    def exist_task_running_fmp()
      @aRunning.each{ |aRunning|
        if (!aRunning.nil?())
          return true  # [Bool]�¹Ծ��֤Υ�������������
        end
      }

      return false  # [Bool]�¹Ծ��֤Υ��������ʤ����
    end

    #=================================================================
    # ��  ��: ��ư����󥿥������������true��
    #         �ʤ�����false���֤�
    #=================================================================
    def exist_nontask_activate_fmp()
      @aActivate.each{ |cActivate|
        if (!cActivate.nil?())
          return true  # [Bool]��ư����󥿥�����������
        end
      }

      return false  # [Bool]��ư����󥿥������ʤ����
    end

    #=================================================================
    # ��  ��: �¹���Υ��������֤�
    #         (ACTIVATE�ʥ������㳰����Ϣ�դ��Ƥ�����ϥ������㳰���֤�)
    #=================================================================
    def get_running_fmp()
      aRunning = []
      @aTask.each{|nPrcid, sObjectID, cObjectInfo|
        if ((cObjectInfo.sObjectType == TSR_OBJ_TASK) && GRP_ACTIVATE.include?(cObjectInfo.hState[TSR_PRM_STATE]))
          if (!cObjectInfo.cTex.nil?() && GRP_ACTIVATE.include?(cObjectInfo.cTex.hState[TSR_PRM_HDLSTAT]))
            aRunning[nPrcid] = cObjectInfo.cTex
          else
            aRunning[nPrcid] = cObjectInfo
          end
        end
      }

      return aRunning  # [Array]�¹���Υ�����
    end

    #=================================================================
    # ��  ��: �¹�����󥿥������֤�
    #=================================================================
    def get_activate_fmp()
      aActivate = []

      @hAllObject.each{|sObjectID, cObjectInfo|
        if (GRP_NON_CONTEXT.include?(cObjectInfo.sObjectType) && GRP_ACTIVATE.include?(cObjectInfo.hState[TSR_PRM_HDLSTAT]))
          aActivate[cObjectInfo.hState[TSR_PRM_PRCID]] = cObjectInfo
        end
      }

      return aActivate  # [Array]�¹�����󥿥���
    end

    #=================================================================
    # ��  ��: CPU���֤��֤�
    #=================================================================
    def get_cpu_state_fmp()
      aCpuState = []
      @hAllObject.each{|sObjectID, cObjectInfo|
        if (cObjectInfo.sObjectType[TSR_OBJ_CPU_STATE])
           aCpuState[cObjectInfo.hState[TSR_PRM_PRCID]] = cObjectInfo
        end
      }
      return aCpuState  # [Array]CPU����
    end

    #=================================================================
    # ��  ��: �¹���ν���ñ�̤��֤�
    #=================================================================
    def get_actvate_running_fmp()
      aProcUnitInfo = []

      @aPrcid.each{ |nPrcid|
        if (!@aActivate[nPrcid].nil?())
          aProcUnitInfo.push(@aActivate[nPrcid])
        elsif (!@aRunning[nPrcid].nil?())
          aProcUnitInfo.push(@aRunning[nPrcid])
        end
      }

      return aProcUnitInfo  # [Array]�¹���ν���ñ��
    end

    #=================================================================
    # ��  ��: �����֥������Ȥ�ref������
    #         IMCodeElement���饹�ˤޤȤ���֤�
    #=================================================================
    def gc_obj_ref_fmp()
      cElement      = IMCodeElement.new()

      # ref��CPU���֡��ѿ��ʳ��Ϥ��٤ƥᥤ��ץ��å�����Ԥ�
      hProcUnitInfo = get_proc_unit_info(@cActivate, @cRunning)

      # �����Ƚ���
      sComment = String.new()
      if (@nSeqNum.nil?() && @nTimeTick.nil?())
        sComment = "#{TSR_LBL_PRE}"
      else
        sComment = "#{TSR_UNS_POST}#{@nSeqNum}_#{@nTimeTick}"
      end
      cElement.set_comment(hProcUnitInfo, sComment)

      @aPrcid.each{|nPrcid|
        # �������㳰��ACTIAVTE���ä���硤texptn/exinf�������Ȱ��פ��Ƥ��뤳�Ȥ��ǧ���륳���ɤ������
        if (@aActivate[nPrcid].nil?() && !@aRunning[nPrcid].nil?() && @aRunning[nPrcid].sObjectType == TSR_OBJ_TASK_EXC)
          @aRunning[nPrcid].gc_assert_texptn_exinf(cElement, get_proc_unit_info(@aRunning[nPrcid]))
        end

        # ����ߥ����ӥ��롼����ACTIAVTE���ä���硤exinf�������Ȱ��פ��Ƥ��뤳�Ȥ��ǧ���륳���ɤ������
        if (!@aActivate[nPrcid].nil?() && @aActivate[nPrcid].sObjectType == TSR_OBJ_ISR)
          @aActivate[nPrcid].gc_assert_exinf(cElement, get_proc_unit_info(@aActivate[nPrcid]))
        end

        # �¹���ν���ñ�̤��ͤ����ꤵ�줿�ѿ�������С����פ��Ƥ��뤳�Ȥ��ǧ���륳���ɤ������
        if (!@aActivate[nPrcid].nil?() && !@aActivate[nPrcid].hState[TSR_PRM_VAR].nil?())
          @aActivate[nPrcid].gc_assert_value(cElement, get_proc_unit_info(@aActivate[nPrcid]))
        elsif (!@aRunning[nPrcid].nil?() && !@aRunning[nPrcid].hState[TSR_PRM_VAR].nil?())
          @aRunning[nPrcid].gc_assert_value(cElement, get_proc_unit_info(@aRunning[nPrcid]))
        end
      }

      # �ᥤ��ץ��å���CPU_STATE��cpu_lock����äƤ��뤫�򻲾�
      bCpuLock = false
      if (!@cCpuState.nil?() && (@cCpuState.hState[TSR_PRM_LOCCPU] == true))
        bCpuLock = true
      end

      # �����֥������Ȥ�ref_code��ޤȤ��
      @hAllObject.each{|sObjectID, cObjectInfo|
        case cObjectInfo.sObjectType
        when TSR_OBJ_CPU_STATE
          # ¾�ץ��å���CPU���֤�¾�ץ��å��μ¹Ծ��֤ν���ñ�̤��黲�Ȥ���
          nPrcid = cObjectInfo.hState[TSR_PRM_PRCID]

          if (!@aActivate[nPrcid].nil?())
            hTempInfo = get_proc_unit_info(@aActivate[nPrcid])
            cElement.set_comment(hTempInfo, "#{sComment} (CPU state)")
            cObjectInfo.gc_obj_ref(cElement, hTempInfo)
          # �ᥤ��ץ��å��ξ��ϡ��¹���Υ����������ʤ��Ƥ�ᥤ�󥿥��������Ȥ���
          elsif (!@aRunning[nPrcid].nil?() || (nPrcid == @sMainPrcid))
            hTempInfo = get_proc_unit_info(@aRunning[nPrcid])
            cElement.set_comment(hTempInfo, "#{sComment} (CPU state)")
            cObjectInfo.gc_obj_ref(cElement, hTempInfo)
          end

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

      # �ᥤ��ץ��å��Υ����å��ݥ����
      cElement.set_checkpoint(hProcUnitInfo)

      return cElement  # [IMCodeElement]�����֥������Ȥ�ref����
    end


    #=================================================================
    # ��  ��: BarrierSync��Ԥ������ɤ��֤�
    #=================================================================
    def gc_barrier_sync()
      cElement      = IMCodeElement.new()
      aProcUnitInfo = [] 

      @aPrcid.each{ |nPrcid|
        if (nPrcid == @sMainPrcid)
          aProcUnitInfo.push(get_proc_unit_info(@cActivate, @cRunning))
        elsif (!@aActivate[nPrcid].nil?())
          aProcUnitInfo.push(get_proc_unit_info(@aActivate[nPrcid]))
        elsif (!@aRunning[nPrcid].nil?())
          aProcUnitInfo.push(get_proc_unit_info(@aRunning[nPrcid]))
        end
      }

      if (aProcUnitInfo.size > 1)
        cElement.set_barrier_sync(aProcUnitInfo)
      end

      return cElement  # [IMCodeElement]BarrierSync��Ԥ�������
    end

    #=================================================================
    # ��  ��: DoStartSync��Ԥ������ɤ��֤�
    #=================================================================
    def gc_do_start_sync(cPrevCondition)
      check_class(Condition, cPrevCondition)  # ���Υ���ǥ������

      cElement = IMCodeElement.new()

      # do��API��ȯ�Ԥ���ץ��å��ʳ��ˤ����ơ����Υ���ǥ������Ǥϼ¹Ծ��֤ǡ�
      # post_conditon�Ǽ¹Ծ��֤ǤϤʤ��ʤ륿�����������硤
      # do��APIȯ�ԤޤǼ¹Ծ��֤ΤޤޤȤ���
      cPrevCondition.aRunning.each{|cObjectInfo|
        if (!cObjectInfo.nil?() && !@hDo.empty?())
          # do��API��ȯ�Ԥ��륪�֥������Ȥ������֤ˤ�����������
          cPreDoObjectInfo = cPrevCondition.get_object_info(@hDo[TSR_PRM_ID])

          # do��API��ȯ�Ԥ��륿�����ξ��ϲ��⤷�ʤ�
          if (cObjectInfo.hState[TSR_PRM_PRCID] == cPreDoObjectInfo.hState[TSR_PRM_PRCID])
            next
          end

          # ���ߤΥ��֥������Ⱦ������
          cNowObjectInfo = get_object_info(cObjectInfo.sObjectID)

          # APIȯ�Ը�˥����å��ݥ���Ȥ����ꤷ���¹Ծ��֤Υ���������Ϥ��Υ����å��ݥ���Ȥ��Ե�����
          if (!GRP_ACTIVATE.include?(cNowObjectInfo.hState[TSR_PRM_STATE]))
            # do��API��ȯ�Ԥ��륪�֥������Ȥθ���֤ˤ�����������
            cPostDoObjectInfo = get_object_info(@hDo[TSR_PRM_ID])

            # ����֤�API��ȯ�Ԥ�������ñ�̤��¹Ծ��֤Ǥʤ��ʤ���ϡ�
            # �ᥤ��ץ��å��μ¹Ծ��֤ν���ñ�̤˥����å��ݥ���Ȥ������
            if (!GRP_ACTIVATE.include?(cPostDoObjectInfo.hState[TSR_PRM_STATE]))
              cElement.set_checkpoint(get_proc_unit_info(@cActivate, @cRunning))
            else
              cElement.set_checkpoint(get_proc_unit_info(cPostDoObjectInfo))
            end
            cElement.set_wait_check_sync(get_proc_unit_info(cObjectInfo), cPostDoObjectInfo.hState[TSR_PRM_PRCID])
          end
        end
      }

      # do��API��ȯ�Ԥ���ץ��å��ʳ��ˤ����ơ����Υ���ǥ������Ǥϼ¹Ծ��֤ǡ�
      # post_conditon�Ǽ¹Ծ��֤ǤϤʤ��ʤ��󥿥����������硤
      # do��APIȯ�ԤޤǼ¹Ծ��֤ΤޤޤȤ���
      cPrevCondition.aActivate.each{|cObjectInfo|
        if (!cObjectInfo.nil?() && !@hDo.empty?())
          # do��API��ȯ�Ԥ��륪�֥������Ȥ������֤ˤ�����������
          cPreDoObjectInfo = cPrevCondition.get_object_info(@hDo[TSR_PRM_ID])

          # do��API��ȯ�Ԥ����󥿥����ξ��ϲ��⤷�ʤ�
          if (cObjectInfo.hState[TSR_PRM_PRCID] == cPreDoObjectInfo.hState[TSR_PRM_PRCID])
            next
          end

          # ���ߤΥ��֥������Ⱦ������
          cNowObjectInfo = get_object_info(cObjectInfo.sObjectID)

          # APIȯ�Ը�˥����å��ݥ���Ȥ����ꤷ���¹Ծ��֤��󥿥�������Ϥ��Υ����å��ݥ���Ȥ��Ե�����
          if (!GRP_ACTIVATE.include?(cNowObjectInfo.hState[TSR_PRM_HDLSTAT]))
            # do��API��ȯ�Ԥ��륪�֥������Ȥθ���֤ˤ�����������
            cPostDoObjectInfo = get_object_info(@hDo[TSR_PRM_ID])

            cElement.set_checkpoint(get_proc_unit_info(cPostDoObjectInfo))
            cElement.set_wait_check_sync(get_proc_unit_info(cObjectInfo), cPostDoObjectInfo.hState[TSR_PRM_PRCID])
          end
        end
      }

      return cElement  # [IMCodeElement]DoStartSync��Ԥ�������
    end

    #=================================================================
    # ��  ��: DoFinishSync��Ԥ������ɤ��֤�
    #=================================================================
    def gc_do_finish_sync(cPrevCondition)
      check_class(Condition, cPrevCondition)  # ���Υ���ǥ������

      cElement = IMCodeElement.new()

      # ¾�ץ��å��ˤ����ơ����Υ���ǥ������Ǥϼ¹Ծ��֤��ä�����
      # �ǥ����ѥå��ˤ��¹Ծ��֤ǤϤʤ��ʤä��������������硤
      # ���Υ����������ߤξ��֤ˤʤ�ޤ��Ե�����(���ref����Τ��ɤ�)
      cPrevCondition.aRunning.each_with_index{|cObjectInfo, nPrcid|
        if (!cObjectInfo.nil?() && (nPrcid != @sMainPrcid))
          # ���ߤΥ��֥������Ⱦ������
          cNowObjectInfo = get_object_info(cObjectInfo.sObjectID)

          # �������㳰�ξ��ϡ���Ϣ�������ξ������Ф�
          if (cNowObjectInfo.sObjectType == TSR_OBJ_TASK_EXC)
            cNowObjectInfo = get_object_info(cNowObjectInfo.hState[TSR_PRM_TASK])
          end

          # �оݥ����������ߤξ��֤ˤʤ�ޤ�StateSync����
          if (!GRP_ACTIVATE.include?(cNowObjectInfo.hState[TSR_PRM_STATE]))
             cElement.set_state_sync(get_proc_unit_info(@cActivate, @cRunning), cNowObjectInfo.sObjectID, cNowObjectInfo.hState[TSR_PRM_STATE])
          end
        end
      }

      return cElement  # [IMCodeElement]DoFinishSync��Ԥ�������
    end

    #=================================================================
    # ��  ��: ���֤�ʤ�������cElement�˳�Ǽ����
    #=================================================================
    def gc_tick_gain_fmp(cElement, aNextActivate, cNextRunning, nGainTick)
      check_class(IMCodeElement, cElement)         # �����ɤ��ɲä��륨�����
      check_class(Array, aNextActivate)            # ���Υ���ǥ�������ACTIVATE�Ǥ����󥿥���
      check_class(ProcessUnit, cNextRunning, true) # ���Υ���ǥ�������Running�Ǥ��륿����
      check_class(Integer, nGainTick)              # �ʤ�����

      hNowProcUnitInfo = get_proc_unit_info(@cRunning)
      hNextProcUnitInfo = get_proc_unit_info(cNextRunning)

      # ¾�ץ��å��˼��Υ���ǥ������ǵ�ư����ACTIVATE���󥿥�����¸�ߤ����硤
      # �ᥤ��ץ��å��ǵ�ư���Ԥ�
      aPrcidProcUnitInfo = []
      aWaitPrcid = []
      @aPrcid.each{|nPrcid|
        if (!aNextActivate[nPrcid].nil?() && (nPrcid != @sMainPrcid))
          cNowObjectInfo = get_object_info(aNextActivate[nPrcid].sObjectID)
          # ��ư��ǧ�ѥ����å��ݥ����
          if (cNowObjectInfo.hState[TSR_PRM_HDLSTAT] == TSR_STT_STP)
            cElement.set_checkpoint(get_proc_unit_info(cNowObjectInfo))
            aPrcidProcUnitInfo.push([hNowProcUnitInfo, nPrcid])
            aWaitPrcid.push(nPrcid)
          else
            cElement.set_checkpoint(get_proc_unit_info(aNextActivate[nPrcid]))
            aPrcidProcUnitInfo.push([hNextProcUnitInfo, nPrcid])
            aWaitPrcid.push(nPrcid)
          end
        end
      }

      # �����륿���������ξ�硤¾�ץ��å��λ��֤��ʤ�Ǥ���ᥤ��ץ��å���ʤ��
      if (@cConf.is_timer_local?())
        if (!aPrcidProcUnitInfo.empty?())
          (1..nGainTick).each{|nCnt|
            if (nCnt == nGainTick)
              # ¾�ץ��å��λ��֤�ʤ�Ƶ�ư����
              gc_tick_gain_local_other_fmp(cElement, aWaitPrcid)
              # �ᥤ��ץ��å��Ǽ¹���Υ������ǵ�ư�������Ȥ��Ԥ�
              aPrcidProcUnitInfo.each{|aPrcidProcUnitInfo|
                cElement.set_wait_check_sync(aPrcidProcUnitInfo[0], aPrcidProcUnitInfo[1])
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
      # �����Х륿���������ϻ��ִ����ץ��å��Υ�����ƥ��å��ζ���Τ߹Ԥ�
      else
        nGainTick.times{
          gc_tick_gain_global_fmp(cElement, aWaitPrcid)
        }

        # ¾�ץ��å���ACTIVATE���󥿥�����ᥤ��ץ��å��Ǽ¹���Υ������ǵ�ư�������Ȥ��Ԥ�
        if (!aPrcidProcUnitInfo.empty?())
          aPrcidProcUnitInfo.each{|aPrcidProcUnitInfo|
            cElement.set_wait_check_sync(aPrcidProcUnitInfo[0], aPrcidProcUnitInfo[1])
          }
        end
      end
    end

    #=================================================================
    # ��  ��: �¹Խ�����뤿���Ʊ���ѥ����ɤ����������֤�
    #=================================================================
    def gc_exec_sequence_sync(cPrevCondition = nil)
      check_class(Condition, cPrevCondition, true)  # ���Υ���ǥ������

      cElement = IMCodeElement.new()

      @aPrcid.each{|nPrcid|
        # ACTIVATE�ʥ������㳰��ACTIVATE���󥿥�����¸�ߤ�����
        if (!@aActivate[nPrcid].nil?() && !@aRunning[nPrcid].nil?() && (@aRunning[nPrcid].sObjectType == TSR_OBJ_TASK_EXC))
          cElement.set_checkpoint(get_proc_unit_info(@aActivate[nPrcid]))
          cElement.set_wait_check_sync(get_proc_unit_info(@aRunning[nPrcid]), nPrcid)
          hRunningTask  = get_proc_unit_info(get_object_info(@aRunning[nPrcid].hState[TSR_PRM_TASK]))
          cElement.set_wait_check_sync(hRunningTask, nPrcid)

          # ACTIVATE���󥿥������Ѥ�ä����ϡ������󥿥������鼡���󥿥����ε�ư���Ԥ�
          if (!cPrevCondition.nil?() && !cPrevCondition.aActivate[nPrcid].nil?() &&
              (cPrevCondition.aActivate[nPrcid].sObjectID != @aActivate[nPrcid].sObjectID))
            cElement.set_wait_check_sync(get_proc_unit_info(cPrevCondition.aActivate[nPrcid]), nPrcid)
          end

        # ACTIVATE���󥿥�����¸�ߤ��� ���� ���Υץ��å��˼¹���Υ������������硤
        # ��˽������ʤޤʤ��褦�󥿥����ε�ư���Ԥ�
        elsif (!@aActivate[nPrcid].nil?() && !@aRunning[nPrcid].nil?())
          cElement.set_checkpoint(get_proc_unit_info(@aActivate[nPrcid]))
          cElement.set_wait_check_sync(get_proc_unit_info(@aRunning[nPrcid]), nPrcid)

          # ACTIVATE���󥿥������Ѥ�ä����ϡ������󥿥������鼡���󥿥����ε�ư���Ԥ�
          if (!cPrevCondition.nil?() && !cPrevCondition.aActivate[nPrcid].nil?() &&
              (cPrevCondition.aActivate[nPrcid].sObjectID != @aActivate[nPrcid].sObjectID))
            cElement.set_wait_check_sync(get_proc_unit_info(cPrevCondition.aActivate[nPrcid]), nPrcid)
          end

        # ACTIVATE�ʥ������㳰��¸�ߤ����硤������¦�ν�������˿ʤޤʤ��褦�������㳰�ε�ư���Ԥ�
        elsif (!@aRunning[nPrcid].nil?() && (@aRunning[nPrcid].sObjectType == TSR_OBJ_TASK_EXC))
          cElement.set_checkpoint(get_proc_unit_info(@aRunning[nPrcid]))
          hRunningTask  = get_proc_unit_info(get_object_info(@aRunning[nPrcid].hState[TSR_PRM_TASK]))
          cElement.set_wait_check_sync(hRunningTask, nPrcid)
        end
      }

      return cElement  # [IMCodeElement]�¹Խ�����뤿���Ʊ���ѥ�����
    end

    #=================================================================
    # ��  ��: �ᥤ��ץ��å��λ��֤�ʤ�������cElement�˳�Ǽ����
    #         (�����륿����������)
    #=================================================================
    def gc_tick_gain_local_main_fmp(cElement)
      check_class(IMCodeElement, cElement)   # �����ɤ��ɲä��륨�����

      hProcUnitInfo = get_proc_unit_info(@cRunning)

      # �ᥤ��ץ��å��ϥ����޳���ߥϥ�ɥ�ν�λ���Ԥ�
      cElement.set_code(hProcUnitInfo, "#{FNC_GAIN_TICK_PE}(#{@sMainPrcid}, true)")
    end

    #=================================================================
    # ��  ��: �ᥤ��ץ��å��ʳ��λ��֤�ʤ�������cElement�˳�Ǽ����
    #         (�����륿����������)
    #=================================================================
    def gc_tick_gain_local_other_fmp(cElement, aWaitPrcid)
      check_class(IMCodeElement, cElement)  # �����ɤ��ɲä��륨�����
      check_class(Array, aWaitPrcid)        # �󥿥����ε�ư���Ԥĥץ��å�ID

      hProcUnitInfo = get_proc_unit_info(@cRunning)

      # ���֤�ʤ�����˥����å��ݥ����
      cElement.set_checkpoint(hProcUnitInfo)

      @aPrcid.each{ |nPrcid|
        if (nPrcid != @sMainPrcid)
          # �󥿥�������ư������ϥ����޳���ߥϥ�ɥ�ν�λ���Ԥ��ʤ�
          if (aWaitPrcid.include?(nPrcid))
            cElement.set_code(hProcUnitInfo, "#{FNC_GAIN_TICK_PE}(#{nPrcid}, false)")
          else
            cElement.set_code(hProcUnitInfo, "#{FNC_GAIN_TICK_PE}(#{nPrcid}, true)")
          end
        end
      }
    end

    #=================================================================
    # ��  ��: ���ץ��å��λ��֤�ʤ�������cElement�˳�Ǽ����
    #         (�����Х륿����������)
    #=================================================================
    def gc_tick_gain_local_all_fmp(cElement)
      check_class(IMCodeElement, cElement)  # �����ɤ��ɲä��륨�����

      hProcUnitInfo = get_proc_unit_info(@cRunning)

      cElement.set_code(hProcUnitInfo, "#{FNC_GAIN_TICK}()")
    end

    #=================================================================
    # ��  ��: �ᥤ��ץ��å��λ��֤�ʤ�������cElement�˳�Ǽ����
    #         (�����Х륿����������)
    #=================================================================
    def gc_tick_gain_global_fmp(cElement, aWaitPrcid)
      check_class(IMCodeElement, cElement)  # �����ɤ��ɲä��륨�����
      check_class(Array, aWaitPrcid)        # �󥿥����ε�ư���Ԥĥץ��å�ID

      hProcUnitInfo = get_proc_unit_info(@cRunning)

      nTimePrcid = @cConf.get_time_manage_prcid()

      # ���ִ����ץ��å����󥿥�������ư������ϥ����޳���ߥϥ�ɥ�ν�λ���Ԥ��ʤ�
      if (aWaitPrcid.include?(nTimePrcid))
        cElement.set_code(hProcUnitInfo, "#{FNC_GAIN_TICK_PE}(#{nTimePrcid}, false)")
      else
        cElement.set_code(hProcUnitInfo, "#{FNC_GAIN_TICK_PE}(#{nTimePrcid}, true)")
      end
    end
  end
end
