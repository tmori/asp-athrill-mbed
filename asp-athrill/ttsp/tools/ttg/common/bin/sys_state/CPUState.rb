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
#  $Id: CPUState.rb 9 2012-09-11 01:47:48Z nces-shigihara $
#
require "common/bin/CommonModule.rb"
require "common/bin/Config.rb"
require "common/bin/IMCodeElement.rb"
require "ttc/bin/sys_state/CPUState.rb"

#=====================================================================
# CommonModule
#=====================================================================
module CommonModule
  #===================================================================
  # ���饹̾: CPUState
  # ��    ��: CPU���֤ξ����������륯�饹
  #===================================================================
  class CPUState
    include CommonModule

    attr_accessor :hState, :sObjectID, :sObjectType

    #=================================================================
    # ��  ��: CPU���֤ν����
    #=================================================================
    def initialize(sObjectID, hObjectInfo, aPath, bIsPre)
      check_class(String, sObjectID)  # ���֥�������ID
      check_class(Hash, hObjectInfo)  # ���֥������Ⱦ���
      check_class(Array, aPath)       # �롼�Ȥ���Υѥ�
      check_class(Bool, bIsPre)       # pre_condition�⤫

      @cConf  = Config.new()
      @hState = {}

      @sObjectID   = sObjectID
      @sObjectType = TSR_OBJ_CPU_STATE
      @aPath       = aPath + [@sObjectID]

      @hState[TSR_PRM_LOCCPU] = nil  # CPU��å�����
      @hState[TSR_PRM_DISDSP] = nil  # �ǥ����ѥå��ػ߾���
      @hState[TSR_PRM_CHGIPM] = nil  # ������ͥ���٥ޥ�������
      @hState[TSR_PRM_PRCID]  = nil  # �ץ��å�ID

      pre_attribute_check(hObjectInfo, aPath + [@sObjectID], bIsPre)
      store_object_info(hObjectInfo)
    end

    #=================================================================
    # ��  ��: �ƥ��ȥ��ʥꥪ��CPU���֥ǡ�����@hState������
    #=================================================================
    def store_object_info(hObjectInfo)
      check_class(Hash, hObjectInfo)  # ���֥������Ⱦ���

      # ��Ǽ
      set_specified_attribute(hObjectInfo)
      hObjectInfo.each{|atr, val|
        if (atr != TSR_PRM_TYPE)
          @hState[atr] = val
        end
      }
    end

    #=================================================================
    # ��  ��: CPU���֤򻲾Ȥ��륳���ɤ�cElement�˳�Ǽ����
    #=================================================================
    def gc_obj_ref(cElement, hProcUnitInfo)
      check_class(IMCodeElement, cElement) # �������
      check_class(Hash, hProcUnitInfo)     # ����ñ�̾���

      # CPU��å�����
      cElement.set_syscall(hProcUnitInfo, "#{API_SNS_LOC}()", @hState[TSR_PRM_LOCCPU], TYP_BOOL_T)

      # �ǥ����ѥå��ػ߾���
      cElement.set_syscall(hProcUnitInfo, "#{API_SNS_DSP}()", @hState[TSR_PRM_DISDSP], TYP_BOOL_T)

      # �����ͥ���٥ޥ���
      cElement.set_local_var(hProcUnitInfo[:id], VAR_INTPRI, TYP_PRI)
      cElement.set_syscall(hProcUnitInfo, "#{FNC_GET_IPM}(&#{VAR_INTPRI})")
      cElement.set_assert(hProcUnitInfo, VAR_INTPRI, @hState[TSR_PRM_CHGIPM])
    end

    #=================================================================
    # ��  ��: �ץ��å�ID���֤�
    #=================================================================
    def get_process_id()
      return @hState[TSR_PRM_PRCID] == nil ? 1 : @hState[TSR_PRM_PRCID] # [Integer]�ץ��å�ID
    end
  end
end
