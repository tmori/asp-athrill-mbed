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
#  $Id: Cyclic.rb 9 2012-09-11 01:47:48Z nces-shigihara $
#
require "ttc/bin/process_unit/ProcessUnit.rb"

#=====================================================================
# CommonModule
#=====================================================================
module CommonModule
  #===================================================================
  # ���饹̾: Cyclic
  # ��    ��: �����ϥ�ɥ�ξ����������륯�饹
  #===================================================================
  class Cyclic < ProcessUnit
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

      ### T3_CYC001: pre_condition��lefttim�����ꤵ��Ƥ���
      if (bIsPre == true && !@hState[TSR_PRM_LEFTTMO].nil?())
        sErr = sprintf("T3_CYC001: " + ERR_CANNNOT_PRE_ATR, TSR_PRM_LEFTTIM)
        aErrors.push(YamlError.new(sErr, @aPath))
      end
      ### T3_CYC002: hdlstat��ACTIVATE�ΤȤ��ˡ�cycstat��TCYC_STA�Ǥʤ�
      if (@hState[TSR_PRM_HDLSTAT] == TSR_STT_ACTIVATE && !is_cyc_sta?())
        aErrors.push(YamlError.new("T3_CYC002: " + ERR_NOT_STA_ON_ACTIVATE, @aPath))
      end
      ### T3_CYC003: hdlstat��ACTIVATE-waitspin�λ���spinid�����ꤵ��Ƥ��ʤ�
      if (@hState[TSR_PRM_HDLSTAT] == TSR_STT_A_WAITSPN && @hState[TSR_PRM_SPINID].nil?())
        aErrors.push(YamlError.new("T3_CYC003: " + ERR_NO_SPINID_WAITING, @aPath))
      end

      check_error(aErrors)
    end

    #=================================================================
    # ��  ��: ����ͤ��䴰����
    #=================================================================
    def complement_init_object_info()
      super()
      hMacro  = @cConf.get_macro()

      # cycatr
      unless (is_specified?(TSR_PRM_CYCATR))
        @hState[TSR_PRM_ATR] = hMacro["ANY_ATT_CYC"]
      end
      # exinf
      unless (is_specified?(TSR_PRM_EXINF))
        @hState[TSR_PRM_EXINF] = hMacro["EXINF_A"]
      end
      # bootcnt
      unless (is_specified?(TSR_PRM_BOOTCNT))
        @hState[TSR_PRM_BOOTCNT] = 0
      end
    end

    #=================================================================
    # ��  ��: ���֤�TCYC_STA�Ǥ��뤫���֤�
    #=================================================================
    def is_cyc_sta?()
      return (@hState[TSR_PRM_STATE] == KER_TCYC_STA)  # [Bool]���֤�TCYC_STA�ξ��true�������Ǥʤ����false
    end
  end
end
