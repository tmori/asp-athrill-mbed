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
require "ttc/bin/class/TTCCommon.rb"

#=====================================================================
# CommonModule
#=====================================================================
module CommonModule
  #===================================================================
  # ���饹̾: CPUState
  # ��    ��: CPU���֤ξ����������륯�饹
  #===================================================================
  class CPUState
    include TTCModule
    include TTCModule::ObjectCommon

    #=================================================================
    # ��  ��: °�������å�
    #=================================================================
    def attribute_check()
      aErrors = []
      @hState.each{|sAtr, val|
        begin
          if (is_specified?(sAtr))
            case sAtr
            # 0�ʲ���������ʸ����
            when TSR_PRM_CHGIPM
              unless (val.is_a?(String))
                check_attribute_le(sAtr, val, 0, @aPath)
              end

            # ������
            when TSR_PRM_LOCCPU, TSR_PRM_DISDSP
              check_attribute_type(sAtr, val, Bool, false, @aPath)

            # 0����礭������
            when TSR_PRM_PRCID
              check_attribute_gt(sAtr, val, 0, @aPath)

            else
              abort(ERR_MSG % [__FILE__, __LINE__])
            end
          end
        rescue TTCError
          aErrors.push($!)
        end
      }

      check_error(aErrors)
    end

    #=================================================================
    # ��  ��: ���֥������ȥ����å�
    # �����: �ʤ�
    #=================================================================
    def object_check(bIsPre = false)
      check_class(Bool, bIsPre)  # pre_condition��

=begin
      aErrors = []
      ### T3_CPU001: loc_id�����ꤵ��Ƥ������CPU��å����֤Ǥʤ�
      if (!@hState[TSR_PRM_LOC_ID].nil?() && @hState[TSR_PRM_LOCCPU] == false)
        aErrors.push(YamlError.new("T3_CPU001: " + ERR_SET_LOC_ID_NOT_CPU_LOCK, @aPath))
      end

      check_error(aErrors)
=end
    end

    #=================================================================
    # ��  ��: ����ͤ��䴰����
    #=================================================================
    def complement_init_object_info()
      # loccpu
      unless (is_specified?(TSR_PRM_LOCCPU))
        @hState[TSR_PRM_LOCCPU] = false
      end
      # disdsp
      unless (is_specified?(TSR_PRM_DISDSP))
        @hState[TSR_PRM_DISDSP] = false
      end
      # chgipm
      unless (is_specified?(TSR_PRM_CHGIPM))
        @hState[TSR_PRM_CHGIPM] = KER_TIPM_ENAALL
      end

      # fmp����
      if (@cConf.is_fmp?())
        # prcid
        unless (is_specified?(TSR_PRM_PRCID))
          @hState[TSR_PRM_PRCID] = CFG_MCR_PRC_SELF
        end
      end
    end

    #=================================================================
    # ������: �䴰��¹Ԥ���
    #=================================================================
    def complement(cPrevObj)
      check_class(CPUState, cPrevObj)  # ľ���ξ��֤Υ��֥�������

      super(cPrevObj)
    end

    #=================================================================
    # ������: ���֥������ȤΥ����ꥢ���Ѵ��ơ��֥���֤�
    #=================================================================
    def get_alias(sTestID, nNum = nil)
      check_class(String, sTestID)      # �ƥ���ID
      check_class(Integer, nNum, true)  # �����ֹ�

      hResult = {}
      hResult[@sObjectID] = alias_str(@sObjectID, sTestID)

      return hResult  # [Hash]�����ꥢ���Ѵ��ơ��֥�
    end

    #=================================================================
    # ������: ���֥������Ȥ�ʣ�������֤�
    #=================================================================
    def dup()
      cObjectInfo = super()

      # ���֥�������IDʣ��
      cObjectInfo.sObjectID = safe_dup(@sObjectID)
      # ���֥������ȥ�����ʣ��
      cObjectInfo.sObjectType = safe_dup(@sObjectType)
      # �ѥ�᡼��ʣ��
      cObjectInfo.hState = safe_dup(@hState)

      return cObjectInfo  # [Object]ʣ���������֥�������
    end

    #=================================================================
    # ��  ��: CPU��å��椫���֤�
    #=================================================================
    def is_cpu_lock?()
      return (@hState[TSR_PRM_LOCCPU] == true)  # [Bool]CPU��å��椫
    end

    #=================================================================
    # ��  ��: �ǥ����ѥå��ػ߾��֤����֤�
    #=================================================================
    def is_disable_dispatch?()
      return (@hState[TSR_PRM_DISDSP] == true)  # [Bool]�ǥ����ѥå��ػ߾��֤�
    end

    #=================================================================
    # ��  ��: �����ͥ���٥ޥ�������������֤����֤�
    #=================================================================
    def is_enable_interrupt?()
      return (@hState[TSR_PRM_CHGIPM] == KER_TIPM_ENAALL || @hState[TSR_PRM_CHGIPM] == 0)  # [Bool]�����ͥ���٥ޥ�������������֤�
    end

    #=================================================================
    # ��  ��: �����Ѳ������ꤵ��Ƥ��뤫���֤�
    #=================================================================
    def is_state_changed?()
      return (is_cpu_lock?() || is_disable_dispatch?() || !is_enable_interrupt?())  # [Bool]�����Ѳ������ꤵ��Ƥ��뤫
    end
  end
end
