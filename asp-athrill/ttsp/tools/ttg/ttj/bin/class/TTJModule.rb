#!ruby -Ke
#
#  TTG
#      TOPPERS Test Generator
#
#  Copyright (C) 2009-2012 by Center for Embedded Computing Systems
#              Graduate School of Information Science, Nagoya Univ., JAPAN
#  Copyright (C) 2010-2011 by Digital Craft Inc.
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
#  $Id: TTJModule.rb 9 2012-09-11 01:47:48Z nces-shigihara $
#
require "common/bin/CommonModule.rb"
require "common/bin/Config.rb"
require "ttj/bin/dictionary.rb"

module TTJModule
  include TTCModule
  include CommonModule

  $aTestScenarios = []  # �ƥ��ȥ��ʥꥪ���ݻ����뤿��Υ����Х��ѿ�
  $sAttrErr       = ""  # ���顼��å�����

  #===================================================================
  # ��  ��: TestScenario�ξ�������ܸ첽�����֤�
  #===================================================================
  def japanize_test_scenario_info()
    cConf     = Config.new()  # �ץ��쥹�С�
    @aTTJInfo = []            # ���ܸ첽����������ݻ����������ѿ�

    # �ϥå��幽¤��°�����ߤ���
    $hTTJAttribute = {}

    GRP_TTJ_ATTRIBUTE.each{|hAttribute|
      hAttribute.each{|key, val|
        $hTTJAttribute.store(key, val)
      }
    }

    # �ץ��쥹�С��ν���
    nCnt   = 0
    nTotal = $aTestScenarios.size()

    # �ƥƥ��ȥ��ʥꥪ�ν���
    $aTestScenarios.each{|cTestScenario|
      nCnt += 1

      if (cConf.is_no_progress_bar_mode?() == true)
        $stderr.puts "[TTJ][#{"%5.1f" % (100 * nCnt.to_f / nTotal.to_f)}\% (#{"%4d" % nCnt}/#{"%4d" % nTotal})] #{cTestScenario.sTestID}"
      else
        print_progress("TTJ", cTestScenario.sTestID, nCnt, nTotal)
      end

      cTSDup = Marshal.load(Marshal.dump(cTestScenario))  # �������ԡ�(cTestScenario���Ƥ��ݸ�Τ���)
      @aTTJInfo.push(cTSDup.japanize_tesry_info())        # ���ܸ첽����
    }

    # �ץ��쥹�С���ɽ���Υꥻ�å�
    if (cConf.is_no_progress_bar_mode?() != true)
      finish_progress("TTJ", nTotal)
    end
  end

  #===================================================================
  # ��  ��: TTC����TESRY�����ɤ��ɹ����TestScenario����������
  #===================================================================
  def japanize_TTC_info(aArgs)
    check_class(Array, aArgs)  # ���ޥ�ɤΰ���

    cTTC = TTC.new()
    $aTestScenarios = cTTC.pre_process(aArgs)
    japanize_test_scenario_info()

    # �Хꥨ�������ǽ������줿�ե���������ɽ��
    cTTC.print_exclude()
  end

  #===================================================================
  # ��  ��: ���̽���
  #===================================================================
  def puts_monitor()
    @aTTJInfo.each{|hTTJInfo|
      hTTJInfo.each{|sObjectID, sObjectInfo|
        $stderr.puts("-" * 70)
        $stderr.puts(sObjectID)
        $stderr.puts("-" * 70)
        $stderr.puts("#{TTJ_NEW_LINE}#{sObjectInfo}#{TTJ_NEW_LINE}")
      }
    }

    if ($sAttrErr.empty?() == false)
      $stderr.puts("== ���ꤵ��Ƥ��ʤ�°�� ==#{TTJ_NEW_LINE}")
      $stderr.puts($sAttrErr)
    end
  end

  #===================================================================
  # ��  ��: �ե��������
  #===================================================================
  def create_file()
    # �ե���������
    File.open(TTJ_PRINT_FILE, "w"){|cIO|
      if ($sAttrErr.empty?() == false)
        cIO.puts("== ���ꤵ��Ƥ��ʤ�°�� ==#{TTJ_NEW_LINE}")
        cIO.puts($sAttrErr)
      end

      @aTTJInfo.each{|hTTJInfo|
        hTTJInfo.each{|sTestID, sTTJInfo|
          cIO.puts("-" * 70)
          cIO.puts(sTestID)
          cIO.puts("-" * 70)
          cIO.puts("#{TTJ_NEW_LINE}#{sTTJInfo}#{TTJ_NEW_LINE}")
        }
      }
    }
  end

end
