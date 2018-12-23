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
#  $Id: Task.rb 9 2012-09-11 01:47:48Z nces-shigihara $
#
require "ttc/bin/process_unit/ProcessUnit.rb"

#=====================================================================
# CommonModule
#=====================================================================
module CommonModule
  #===================================================================
  # ���饹̾: Task
  # ��    ��: �������ξ����������륯�饹
  #===================================================================
  class Task < ProcessUnit
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

      # �Ԥ����֤ξ��
      if (GRP_TASK_WAITING.include?(@hState[TSR_PRM_STATE]))
        ### T3_TSK001: ���֤��Ԥ����֤Ǥ���Τ��Ԥ��оݤ����ꤵ��Ƥ��ʤ�
        if (@hState[TSR_PRM_WOBJID].nil?())
          aErrors.push(YamlError.new("T3_TSK001: " + ERR_NO_WOBJID_WAITING, @aPath))
        ### T3_TSK002: ���֤��Ԥ����֤��Ԥ��оݤ�SLEEP�ξ��˵����׵ᥭ�塼���󥰿������ꤵ��Ƥ���
        elsif (@hState[TSR_PRM_WOBJID] == TSR_STT_SLEEP && !@hState[TSR_PRM_WUPCNT].nil?() && @hState[TSR_PRM_WUPCNT] > 0)
          aErrors.push(YamlError.new("T3_TSK002: " + ERR_SLEEPING_CANNOT_WUP, @aPath))
        ### T3_TSK003: pre_condition��DELAY�Ԥ��λ������л��֤����ꤵ��Ƥ��ʤ�
        elsif (bIsPre == true && @hState[TSR_PRM_WOBJID] == TSR_STT_DELAY && @hState[TSR_PRM_LEFTTMO].nil?())
          aErrors.push(YamlError.new("T3_TSK003: " + ERR_NO_LEFTTMO_DELAY, @aPath))
        end
      ### T3_TSK004: �Ԥ����֤ǤϤʤ��Τ��Ԥ��оݤ����ꤵ��Ƥ���
      elsif (!@hState[TSR_PRM_WOBJID].nil?())
        aErrors.push(YamlError.new("T3_TSK004: " + ERR_SET_WOBJID_NO_WAITING, @aPath))
      end

      ### T3_TSK005: actcnt��0�Ǥ���Τ�actprc�����ꤵ��Ƥ���
      if (@hState[TSR_PRM_ACTCNT] == 0 && !@hState[TSR_PRM_ACTPRC].nil?() && @hState[TSR_PRM_ACTPRC] != KER_TPRC_NONE)
        aErrors.push(YamlError.new("T3_TSK005: " + ERR_SET_ACTPRC_NO_ACTCNT, @aPath))
      end
      ### T3_TSK006: ���֤����ԥ��å������Ԥ��λ���spinid�����ꤵ��Ƥ��ʤ�
      if (@hState[TSR_PRM_STATE] == TSR_STT_R_WAITSPN && @hState[TSR_PRM_SPINID].nil?())
        aErrors.push(YamlError.new("T3_TSK006: " + ERR_NO_SPINID_WAITING, @aPath))
      end

      # dormant�Υ�����
      if (is_dormant?())
        @aSpecifiedAttributes.each{|sAtr|
          ### T3_TSK007: �ٻ߾��֤ξ��˻���Ǥ��ʤ��ѥ�᡼�������ꤵ��Ƥ���
          if (sAtr != TSR_PRM_TYPE && !GRP_ACTIVATE_PRM_ON_DORMANT[TSR_OBJ_TASK].include?(sAtr))
            sErr = sprintf("T3_TSK007: " + ERR_ATR_DORMANT_TASK, sAtr)
            aErrors.push(YamlError.new(sErr, @aPath))
          end
        }
      end

      check_error(aErrors)
    end

    #=================================================================
    # ��  ��: ����ͤ��䴰����
    #=================================================================
    def complement_init_object_info()
      super()
      hMacro  = @cConf.get_macro()

      # tskpri
      unless (is_specified?(TSR_PRM_TSKPRI))
        @hState[TSR_PRM_TSKPRI]  = hMacro["TSK_PRI_MID"]
      end
      # itskpri
      unless (is_specified?(TSR_PRM_ITSKPRI))
        @hState[TSR_PRM_ITSKPRI] = hMacro["TSK_PRI_MID"]
      end
      # exinf
      if (!is_specified?(TSR_PRM_EXINF) && @sObjectType != TSR_OBJ_TASK_EXC)
        @hState[TSR_PRM_EXINF] = hMacro["EXINF_A"]
      end
      # bootcnt
      unless (is_specified?(TSR_PRM_BOOTCNT))
        @hState[TSR_PRM_BOOTCNT] = 0
      end
    end

    #=================================================================
    # ������: �䴰��¹Ԥ���
    #=================================================================
    def complement(cPrevObjectInfo)
      check_class(ProcessUnit, cPrevObjectInfo)  # ľ���Υ��֥������Ⱦ���

      super(cPrevObjectInfo)

      # �䴰�㳰(1)
      if (!is_specified?(TSR_PRM_WOBJID) && (cPrevObjectInfo.hState[TSR_PRM_STATE] == KER_TTS_WAI ||
          cPrevObjectInfo.hState[TSR_PRM_STATE] == KER_TTS_WAS) && 
          (@hState[TSR_PRM_STATE] != KER_TTS_WAI && @hState[TSR_PRM_STATE] != KER_TTS_WAS))
        @hState[TSR_PRM_WOBJID] = nil
        @hState[TSR_PRM_TSKWAIT] = nil
      end
      # �䴰�㳰(2)
      if (!is_specified?(TSR_PRM_LEFTTMO) && (cPrevObjectInfo.hState[TSR_PRM_STATE] == KER_TTS_WAI ||
          cPrevObjectInfo.hState[TSR_PRM_STATE] == KER_TTS_WAS) && 
          !cPrevObjectInfo.hState[TSR_PRM_WOBJID].nil?() && !cPrevObjectInfo.hState[TSR_PRM_LEFTTMO].nil?() &&
          ((@hState[TSR_PRM_STATE] != KER_TTS_WAI && @hState[TSR_PRM_STATE] != KER_TTS_WAS) || 
           cPrevObjectInfo.hState[TSR_PRM_WOBJID] != @hState[TSR_PRM_WOBJID]))
        @hState[TSR_PRM_LEFTTMO] = nil
      end
      # �䴰�㳰(4)
      if (!is_specified?(TSR_PRM_PORDER) && (cPrevObjectInfo.hState[TSR_PRM_STATE] != @hState[TSR_PRM_STATE] ||
          cPrevObjectInfo.hState[TSR_PRM_TSKPRI] != @hState[TSR_PRM_TSKPRI]))
        @hState[TSR_PRM_PORDER] = nil
      end
    end

    #=================================================================
    # ������: ���䴰��λ��˼¹Ԥ������
    #=================================================================
    def complement_after()
      # dormant�ξ�硤�����Υѥ�᡼����̵���Ȥ���
      if (@hState[TSR_PRM_STATE] == KER_TTS_DMT)
        @hState.each_key{|sAtr|
          if (!is_specified?(sAtr) && !GRP_COMPLEMENT_PRM_ON_DORMANT.include?(sAtr))
            @hState[sAtr] = nil
          end
        }
      end
    end

    #=================================================================
    # ������: �Ԥ��оݤ����ꤵ��Ƥ��뤫���֤�
    #=================================================================
    def has_wait_target?()
      return !(@hState[TSR_PRM_WOBJID].nil?())
    end

    #=================================================================
    # ������: �Ԥ����֥������Ȥ����ꤵ��Ƥ��뤫���֤�
    #=================================================================
    def has_wait_object?()
      return (has_wait_target?() && !GRP_WAIT_NON_OBJECT.include?(@hState[TSR_PRM_WOBJID]))  # [Bool]�Ԥ����֥������Ȥ����ꤵ��Ƥ��뤫
    end

    #=================================================================
    # ������: �¹Բ�ǽ���֤����֤�
    #=================================================================
    def is_ready?()
      return (@hState[TSR_PRM_STATE] == KER_TTS_RDY)  # [Bool]�¹Բ�ǽ���֤�
    end

    #=================================================================
    # ������: ���֥��������Ԥ����֤����֤�
    #=================================================================
    def is_object_waiting?()
      return ([KER_TTS_WAI, KER_TTS_WAS].include?(@hState[TSR_PRM_STATE]))  # [Bool]���֥��������Ԥ����֤�
    end

    #=================================================================
    # ������: �ٻ߾��֤����֤�
    #=================================================================
    def is_dormant?()
      return (@hState[TSR_PRM_STATE] == KER_TTS_DMT)  # [Bool]�ٻ߾��֤�
    end

    #=================================================================
    # ������: ���Ͼ��֤����֤�
    #=================================================================
    def is_running_suspended?()
      return (@hState[TSR_PRM_STATE] == KER_TTS_RUS)  # [Bool]���Ͼ��֤�
    end
  end
end
